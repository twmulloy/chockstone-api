module Chockstone
  class Connection

    def initialize *args
      
      return unless args[0].is_a?(Hash)

      options = args[0]
      @url = options[:url]

      uri = URI(@url)
      @host   = uri.host
      @port   = uri.port
      @scheme = uri.scheme
      @path   = uri.path

      @domain         = options[:domain]
      @profile        = options[:profile]
      @seller_profile = options[:seller_profile]
      @password       = options[:password]

      connection

    end

    # api requests
    def auth_user id, password

      request('authenticate-user', 
        :user => { 
          :id => id,
          :password => password
        }
      )

    end
    alias :authenticate_user :auth_user

    def get_user id

      request('get-user', 
        :user => { 
          :id => id 
        }
      )

    end

    # account argument hash will invoke an account creation
    def create_user user={}, account={}

      req = {}
      req.merge!({ :user => user }) unless user.empty?
      req.merge!({ :account => account }) unless account.empty?

      request('create-user', req)

    end

    def update_user user={}
      request('update-user', 
        :user => user
      )
    end

    # update user 'id' (email)
    def update_user_id id, new_id
      request('update-user-id', 
        :old => {
          :user => {
            :id => id
          }
        },
        :new => {
          :user => {
            :id => new_id
          }
        }
      )
    end

    def update_user_password id, password
      request('update-user-password',
        :user => {
          :id => id,
          :password => password
        }
      )
    end

    def add_user_bank_card id, card={}
      request('add-user-bank-card',
        :user => {
          :id => id
        },
        :bank_card => card
      )
    end

    def delete_user_bank_card id, card_id
      request('delete-user-bank-card',
        :user => {
          :id => id
        },
        :bank_card => {
          :id => card_id
        }
      )

    end

    # need to pass the authorization request block as a hash
    # ex. "pin authorization":
    # {
    #   :pin_authorization => {
    #     :id => '6277111111111111',
    #     :pin => '1234'
    #   }
    # }
    # 
    # ex. "credit-card-authorization":
    # {
    #   :credit_card_authorization => {
    #     :number => '',
    #     :expiration_date => {
    #       :month => '',
    #       :year => ''
    #     },
    #     :cvv2 => ''
    #   }
    # }
    # 
    # ex. "phone-number-authorization":
    # {
    #   :phone_number_authorization => {
    #     :number => '',
    #     :pin => ''
    #   }
    # }
    def get_account_balance authorization={}
      request('get-account-balance', 
        :account => authorization
      )
    end

    # need to pass the authorization request block as a hash
    # ex. "credit-card-authorization":
    # {
    #   :credit_card_authorization => {
    #     :number => '',
    #     :expiration_date => {
    #       :month => '',
    #       :year => ''
    #     },
    #     :cvv2 => ''
    #   }
    # }
    # 
    # ex. "phone-number-authorization":
    # {
    #   :phone_number_authorization => {
    #     :number => '',
    #     :pin => ''
    #   }
    # }
    def update_account_alias account_id, authorization={}

      req = {
        :id => account_id
      }

      req.merge!(authorization)

      request('update-account-alias', 
        :account => req
      )
    end


    # page argument needs to be a hash with the page
    # at a bare minimum your page argument hash needs to include:
    # {
    #   :number => 1,
    #   :transactions_per_page => 50,
    #   :sort_by_date => 'descending' #(descending|ascending)
    # }
    def view_account_activity account_id, page={}

      request('view-account-activity',  
        :account => {
          :id => account_id
        },
        :page => page
      )
    end

    def transfer_account from, to
      request('transfer-account',
        :from => {
          :account => {
            :id => from
          }
        },
        :to => {
          :account => {
            :id => to
          }
        }
      ) 
    end




  private

    def transmit xml
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = true if @scheme == "https"
      request = Net::HTTP::Post.new(@path)
      request.body = xml.to_s
      resp = http.start{ |http| http.request(request) }
      response(resp.body)
    end

    def response resp

      p = XML::Parser.string(resp)
      doc = p.parse

      #puts doc

      response = doc.find('//response')[0]
      status = response.find('//status')[0]

      alert_name = status.find('//alert-name')[0]
      alert_type = status.find('//alert-type')[0]

      alert = {
        :name => alert_name ? alert_name.content : nil,
        :type => alert_type ? alert_type.content : nil
      }

      method = status.find('//type')[0].content
      data = Hash.from_xml(response.find("//#{method}")[0].to_s)

      formatted_response = {
        :status => status.find('//code')[0].content,
        :method => method,
        :description => status.find('//description')[0].content
      }

      formatted_response.merge!({ :alert => alert }) unless alert[:name].nil? and alert[:type].nil?
      formatted_response.merge!({ :data => key_to_sym(data) }) unless data.blank?

      formatted_response

    end

    def request method, params={}

      # initial xml request
      xml = @hash_connection.merge({ 
          method => params 
        }).to_xml(
          :root => 'request', 
          :skip_types => true
        )

      # parse the inital xml to manipulate nodes
      xml = XML::Parser.string(xml).parse

      # apply attributes to request node
      req = xml.find('//request')[0]
      req.attributes['version'] = '1'
      req.attributes['revision'] = '2'
      req.attributes['expirationDetail'] = 'true'

      #puts xml

      transmit(xml)
    end

    # connection node for request
    def connection

      @hash_connection = {
        :connection => {
          :domain => @domain,
          :store_id => @profile,
          :service_user => @seller_profile,
          :service_password => @password
        }
      }

    end

    def key_to_sym hash
      return hash unless hash.is_a?(Hash)
      hash = hash.inject({}){|memo,(k,v)| memo[k.to_sym] = key_to_sym(v); memo}
      hash
    end
  end

end