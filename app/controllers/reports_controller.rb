class ReportsController < ApplicationController
  before_action :require_admin, only: %i[index, show]

  def index
    @reports = Report.includes(reporter_user: :profile, reported_user: :profile)
  end

  def create
    report = current_user.active_reports.build(report_params)
    user = User.find(report_params[:reported_user_id])
    if report.save
      flash[:notice] = "#{user.profile.username}さんを通報しました"
      redirect_to profile_path(user.profile)
    else
      flash[:alert] = "入力内容に誤りがあります"
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @report = Report.find(params[:id])
  end

  private

  def report_params
    params.require(:report).permit(:description, :reported_user_id)
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end
end
