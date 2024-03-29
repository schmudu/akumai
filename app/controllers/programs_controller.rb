class ProgramsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_program, only: [:show, :edit, :update, :destroy]

  def user_level
    if current_user.is_superuser?
      user_level = ConstantsHelper::ROLE_LEVEL_SUPERUSER
    else
      program = current_user.programs.find_by_slug(params[:program])
      user_level = program.roles.find_by_user_id(current_user.id).level
    end

    respond_to do |format|
      msg = { :level => "#{user_level}" }
      format.json { render :json => msg }
    end
  end

  # GET /programs
  # GET /programs.json
  def index
    @programs = Program.paginate(page: params[:page])
  end

  # GET /programs/1
  # GET /programs/1.json
  def show
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  # POST /programs.json
  def create
    @program = Program.new(program_params)

    if @program.save
      Role.create(:user_id => current_user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN)
      redirect_to @program, notice: 'Program was successfully created.'
    else
      render action: 'new' 
    end
  end

  # PATCH/PUT /programs/1
  # PATCH/PUT /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to @program, notice: 'Program was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1
  # DELETE /programs/1.json
  def destroy
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_params
      params.require(:program).permit(:code, :name)
    end
end
