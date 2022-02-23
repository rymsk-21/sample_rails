require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # 完全に削除されたか？
    log_in_as(@user)
    # ログインさせる
    get root_path
    # ホーム画面に転送することを要求
    assert_select 'div.pagination'
    # 要求が認められページネートが表示されているか？
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      # 投稿が無効
      post microposts_path, params: { micropost: { content: "" } }
      # 空の投稿
    end
    assert_select 'div#error_explanation'
    # エラ〜メッセージが表示されているか？
    assert_select 'a[href=?]', '/?page=2'
    # 正しいページネーションリンク
    # ページネートが２ページに行くか？
    content = "This micropost really ties the room together"
    # 有効なマイクロポスト
    assert_difference 'Micropost.count', 1 do
      # 投稿の数の差が１かどうか？
      post microposts_path, params: { micropost: { content: content } }
      # 投稿する
    end
    assert_redirected_to root_url
    # root_urlにリダイレクトされているか？
    follow_redirect!
    # 後から調べる
    assert_match content, response.body
    # マイクロポストの数があれば、コンテントがあるか？
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    # aタグにdeleteがあるか？
    first_micropost = @user.microposts.paginate(page: 1).first
    #１枚目の 1番目のマイクロポストを返す
    assert_difference 'Micropost.count', -1 do
      # 削除して一つ減っているか？
      delete micropost_path(first_micropost)
      # 先のマイクロポストを削除する
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:archer))
    # archerのuser_pathに行くことを要求
    assert_select 'a', text: 'delete', count: 0
    # aタグのdeleteが表示されていないか？
  end
end