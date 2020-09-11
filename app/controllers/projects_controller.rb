class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :update, :destroy, :edit]

  def index
    @projects = Project.all.order("created_at DESC")
  end

  def edit
    @users = User.fellows.active
    @partners = RefPartner.active
  end

  def new
    @project = Project.new
    @users = User.fellows.active
    @partners = RefPartner.active
  end

  def show
    @project_user = ProjectUser.new
    @project_partner = ProjectRefPartner.new
    @users = User.fellows.active.where.not(id: @project.users.pluck(:id))
    @partners = RefPartner.active.where.not(id: @project.ref_partners.pluck(:id))
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project was created successfully"
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { respond_with_bip(@project) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@project) }
      end
    end
  end

  def destroy
    @project.project_users.delete_all
    @project.project_ref_partners.delete_all
    if @project.destroy
      redirect_to projects_path, notice: "Project was destroyed successfully"
    else
      redirect_to projects_path, notice: "Something went wrong"
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :name_list, :partner_list)
  end
end
