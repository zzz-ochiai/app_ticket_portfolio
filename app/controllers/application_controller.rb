class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      super
    end
  end
end

# ＜学習メモ＞
# stale_when_importmap_changesはimportmap の内容が変わったら、ブラウザにJavaScriptを再取得させるための仕組み
# ⇒importmap-railsが提供している機能
# after_sign_out_path_forはDeviseで定義されたオーバーライド用のメソッド⇒ログアウト後の遷移先を指定
# new_admin_session_pathは遷移先のパスを自動生成⇒devise_for :adminsに対応して/admins/sign_inを生成
# after_sign_out_path_for(resource_or_scope)における引数は認証スコープが呼ばれる
