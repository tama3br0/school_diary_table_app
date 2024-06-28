class UsersController < ApplicationController
    before_action :authenticate_user!
    include UsersHelper

    def additional_info
        @user = current_user
    end

    def save_additional_info
        @user = current_user
        @user.skip_validations = false

        begin
            # GradeClass モデルに対して find_or_create_by メソッドを使って、指定された grade（学年）、class_num（クラス番号）、および school_code（学校コード）に一致するレコードを検索・見つからない場合は作成
            grade_class = GradeClass.find_or_create_by(
            grade: params[:user][:grade].to_i,
            class_num: params[:user][:class_num].to_i,
            school_code: params[:user][:school_code].to_i
            )

            # 現在のユーザー (@user) の grade_class 属性に、先ほど取得または作成した grade_class オブジェクトを設定。これにより、ユーザーが所属する学年とクラスの情報が関連付けられる
            @user.grade_class = grade_class
            # assign_attributes メソッドは、user_params から取得したパラメータをユーザーオブジェクト (@user) に設定する。ここでは、:grade、:class_num、:school_code を除外しているため、これらの属性は GradeClass モデルに属する情報として処理され、それ以外の属性（例えば role、name、student_num など）が @user に設定される。
            @user.assign_attributes(user_params.except(:grade, :class_num, :school_code))
            @user.additional_info_provided = true # trueで、ユーザーが追加情報を提供したことを示す

            # ユーザーオブジェクトが有効であり(User モデルで定義されているバリデーションを通過するかどうかをチェック)、かつ unique_combination? メソッドを通過するかどうか(@user がユニークな組み合わせ（同じ grade_class と student_num を持つユーザーが存在しない）であるかどうかを確認)を確認
            if @user.valid? && unique_combination?(@user, grade_class, @user.student_num)
                @user.save
                respond_to do |format|
                    format.html { redirect_to authenticated_root_path, notice: 'とうろく できました！' }
                end
            else
                flash.now[:alert] = @user.errors.full_messages.join("\n")
                flash.now[:alert] = "すでに とうろくされているひとが います" if @user.errors[:student_num].include?("すでに、ほかのひとが とうろく されています")

                respond_to do |format|
                    format.html { render :additional_info }
                end
            end
        rescue => e
            Rails.logger.error("Error in save_additional_info: #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))
            flash.now[:alert] = "おうちのひとにきくか、あした せんせいに きいてね！(予期しないエラーが発生しました)"
            render :additional_info
        end
    end

    private

    def user_params
        params.require(:user).permit(:role, :name, :student_num, :grade, :class_num, :school_code)
    end
end
