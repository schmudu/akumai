require 'spec_helper'

describe MappedCourse do
  before do
    @program = FactoryGirl.create(:program) 
    @another_program = FactoryGirl.create(:program) 
    @core_course = FactoryGirl.create(:core_course, :name => "Geometry")
    @mapped_course = FactoryGirl.build(:mapped_course, :name => "Geometry", 
      :core_course_id => @core_course.id,
      :program_id => @program.id)
  end

  subject  { @mapped_course }

  it { should be_valid }

  describe "validation" do
    describe "core_course_id" do
      describe "set to nil" do
        before { @mapped_course.core_course_id = nil }
        it { should_not be_valid }
      end

      describe "set to non-existent core_course id" do
        before { @mapped_course.core_course_id = -99 }
        it { should_not be_valid }
      end
    end

    describe "program_id" do
      describe "set to nil" do
        before { @mapped_course.program_id = nil }
        it { should_not be_valid }
      end

      describe "set to non-existent program id" do
        before { @mapped_course.program_id = -99 }
        it { should_not be_valid }
      end
    end

    describe "name" do
      describe "set to nil" do
        before { @mapped_course.name = nil }
        it { should_not be_valid }
      end

      describe "set to blank" do
        before { @mapped_course.name = "" }
        it { should_not be_valid }
      end

      describe "duplicates" do
        describe "with same name" do
          before do
            @mapped_course.save
            @duplicate_core_course = FactoryGirl.build(:mapped_course, :name => "Geometry", 
              :core_course_id => @core_course.id,
              :program_id => @program.id)
          end

          it "duplicate course should not be valid" do
            @duplicate_core_course.should_not be_valid
          end
        end

        describe "with same name but different program" do
          before do
            @mapped_course.save
            @duplicate_core_course = FactoryGirl.build(:mapped_course, :name => "Geometry", 
              :core_course_id => @core_course.id,
              :program_id => @another_program.id)
          end

          it "duplicate course should be valid" do
            @duplicate_core_course.should be_valid
          end
        end

        describe "with change of case" do
          before do
            @mapped_course.save
            @duplicate_core_course = FactoryGirl.build(:mapped_course, :name => "geometrY")
          end

          it "duplicate course should not be valid" do
            @duplicate_core_course.should_not be_valid
          end
        end
      end
    end
  end

  describe "scrub" do
    describe "abbreviation" do
      before do
        FactoryGirl.create(:mapped_course, :name => "Alg 2", 
          :core_course_id => @core_course.id,
          :program_id => @program.id)
      end

      it "should downcase word" do
        course = MappedCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "capitalization" do
      before do
        FactoryGirl.create(:mapped_course, :name => "Algebra 2", 
          :core_course_id => @core_course.id,
          :program_id => @program.id)
      end

      it "should downcase word" do
        course = MappedCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "numerals" do
      before do
        FactoryGirl.create(:mapped_course, :name => "Algebra II", 
          :core_course_id => @core_course.id,
          :program_id => @program.id)
      end

      it "should replace with number" do
        course = MappedCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "white spaces" do
      describe "should insert" do
        before do
          FactoryGirl.create(:mapped_course, :name => "algebra2", 
            :core_course_id => @core_course.id,
            :program_id => @program.id)
        end

        it "should insert one whitespace" do
          course = MappedCourse.last
          course.name.should == "algebra 2"
        end
      end

      describe "should remove" do
        before do
          FactoryGirl.create(:mapped_course, :name => "algebra   2", 
            :core_course_id => @core_course.id,
            :program_id => @program.id)
        end

        it "remove extra whitespaces" do
          course = MappedCourse.last
          course.name.should == "algebra 2"
        end
      end
    end
  end
end
