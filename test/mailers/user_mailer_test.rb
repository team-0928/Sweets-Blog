require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウント有効化のお願い", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name, mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
    assert_match user.activation_token, mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
    assert_match CGI.escape(user.email),  mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "パスワードの再設定について", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
    assert_match CGI.escape(user.email),  mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
  end
end
