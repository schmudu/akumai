class CoreCoursesController < ApplicationController
  # TODO: superuser only
  before_filter :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /core_courses
  # GET /core_courses.json
  def index
    @courses = CoreCourse.paginate(page: params[:page])
  end

  # GET /core_courses/1
  # GET /core_courses/1.json
  def show
  end

  # GET /core_courses/new
  def new
    @course = CoreCourse.new
  end

  # GET /core_courses/1/edit
  def edit
  end

  # POST /core_courses
  # POST /core_courses.json
  def create
    @course = CoreCourse.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Core Course was successfully created.'
    else
      render action: 'new' 
    end
  end

  # PATCH/PUT /core_courses/1
  # PATCH/PUT /core_courses/1.json
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Core Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /core_courses/1
  # DELETE /core_courses/1.json
  def destroy
    @program.destroy
    redirect_to programs_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = CoreCourse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:core_course).permit(:name)
    end
end
