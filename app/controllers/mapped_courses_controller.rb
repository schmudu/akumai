class MappedCoursesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /mapped_courses
  # GET /mapped_courses.json
  def index
    @mapped_courses = MappedCourse.paginate(page: params[:page])
  end

  # GET /mapped_courses/1
  # GET /mapped_courses/1.json
  def show
  end

  # GET /mapped_courses/new
  def new
    @course = MappedCourse.new
    @programs = current_user.staff_level_programs
    @core_courses = CoreCourse.all
  end

  # GET /mapped_courses/1/edit
  def edit
  end

  # POST /mapped_courses
  # POST /mapped_courses.json
  def create
    @course = MappedCourse.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Mapped Course was successfully created.'
    else
      @programs = current_user.staff_level_programs
      @core_courses = CoreCourse.all
      render action: 'new' 
    end
  end

  # PATCH/PUT /mapped_courses/1
  # PATCH/PUT /mapped_courses/1.json
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Mapped Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /mapped_courses/1
  # DELETE /mapped_courses/1.json
  def destroy
    @program.destroy
    redirect_to programs_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = MappedCourse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:mapped_course).permit(:name, :program_id, :core_course_id)
    end
end
