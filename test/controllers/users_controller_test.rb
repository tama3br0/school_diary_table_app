require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @user = users(:one) # テスト用のユーザーを用意します
        sign_in @user
    end

    test "異なる学校コードで同じ学年・クラス・出席番号を持つユーザーが登録できる" do
        assert_difference('User.count') do
            post save_additional_info_path, params: {
                user: {
                role: @user.role,
                name: "テスト学生",
                student_num: @user.student_num,
                grade: @user.grade_class.grade,
                class_num: @user.grade_class.class_num,
                school_code: @user.grade_class.school_code + 1 # 異なる学校コードを使用
                }
            }
        end
        assert_redirected_to authenticated_root_path
        follow_redirect!
        assert_match /とうろく できました！/, response.body
    end

    test "同じ学校コードで同じ学年・クラス・出席番号を持つユーザーが登録できない" do
        post save_additional_info_path, params: {
        user: {
            role: @user.role,
            name: "テスト学生",
            student_num: @user.student_num,
            grade: @user.grade_class.grade,
            class_num: @user.grade_class.class_num,
            school_code: @user.grade_class.school_code # 同じ学校コードを使用
        }
        }

        assert_no_difference('User.count') do
            post save_additional_info_path, params: {
                user: {
                role: @user.role,
                name: "テスト学生",
                student_num: @user.student_num,
                grade: @user.grade_class.grade,
                class_num: @user.grade_class.class_num,
                school_code: @user.grade_class.school_code # 同じ学校コードを使用
                }
            }
        end

        assert_response :success
        assert_match /すでに、ほかのひとが とうろく されています/, response.body
    end
end
