require 'test/unit'
require 'chockstone'

class ChockstoneTest < Test::Unit::TestCase

  # YOUR CREDENTIALS
  CREDENTIALS = {

  }

  # YOUR TEST USER
  TEST_USER = {

  }

  TEST_USER_ACCOUNT = {
    # use one of the following authorization methods
    :pin_authorization => {
      :id => '6277111111111111',
      :pin => '1234'
    }

    # :credit_card_authorization => {
    #   :number => '62771111222233334444',
    #   :expiration_date => {
    #     :month => '01',
    #     :year => '10'
    #   },
    #   :cvv2 => '010'
    # }

    # :phone_number_authoirzation => {
    #   :number => '5035551212',
    #   :pin => '1234'
    # }

  }

  def setup
    @cs = Chockstone::Connection.new CREDENTIALS
    @bogus_user = 'loyal-vistor@example.com'
    @bogus_password = 'MyBogusPassword'
  end

  def test_chockstone_module
    assert_not_nil @cs
  end

  def test_get_user_fail
    resp = @cs.get_user @bogus_user

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("get-user", resp[:method], "api did not respond with proper method")
  end

  def test_get_user_fail
    resp = @cs.auth_user @bogus_user, @bogus_password

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("authenticate-user", resp[:method], "api did not respond with proper method")

  end

  def test_create_user_fail

    user = TEST_USER
    account = TEST_USER_ACCOUNT || nil

    resp = @cs.create_user(user, account)

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("create-user", resp[:method], "api did not respond with proper method")
  end

  def test_update_user_fail

    user = TEST_USER

    # remove password from our generic user
    user.delete :password

    resp = @cs.update_user(TEST_USER)

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("update-user", resp[:method], "api did not respond with proper method")

  end

  def test_update_user_id_fail
    resp = @cs.update_user_id @bogus_user, @bogus_user

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("update-user-id", resp[:method], "api did not respond with proper method")
  end

  def test_update_user_password
    resp = @cs.update_user_password(@bogus_user, @bogus_password)

    assert_block "response is a hash and has a status" do
      resp.is_a?(Hash) and resp.include?(:status)
    end

    assert_equal("fail", resp[:status], "api did not response with fail status: "+resp.to_s)
    assert_equal("update-user-password", resp[:method], "api did not respond with proper method")
  end


end