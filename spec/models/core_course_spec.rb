require 'spec_helper'

describe CoreCourse do
  before do
    @core_course = FactoryGirl.build(:core_course, :name => "Geometry")
  end

  subject  { @core_course }

  it { should be_valid }

  describe "validation" do
    describe "name" do
      describe "set to nil" do
        before { @core_course.name = nil }
        it { should_not be_valid }
      end

      describe "set to blank" do
        before { @core_course.name = "" }
        it { should_not be_valid }
      end

      describe "duplicates" do
        describe "with same name" do
          before do
            @core_course.save
            @duplicate_core_course = FactoryGirl.build(:core_course, :name => "Geometry")
          end

          it "duplicate course should not be valid" do
            @duplicate_core_course.should_not be_valid
          end
        end

        describe "with change of case" do
          before do
            @core_course.save
            @duplicate_core_course = FactoryGirl.build(:core_course, :name => "geometrY")
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
        FactoryGirl.create(:core_course, :name => "Alg 2")
      end

      it "should downcase word" do
        course = CoreCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "capitalization" do
      before do
        FactoryGirl.create(:core_course, :name => "Algebra 2")
      end

      it "should downcase word" do
        course = CoreCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "numerals" do
      before do
        FactoryGirl.create(:core_course, :name => "Algebra II")
      end

      it "should replace with number" do
        course = CoreCourse.last
        course.name.should == "algebra 2"
      end
    end

    describe "white spaces" do
      describe "should insert" do
        before do
          FactoryGirl.create(:core_course, :name => "algebra2")
        end

        it "should insert one whitespace" do
          course = CoreCourse.last
          course.name.should == "algebra 2"
        end
      end

      describe "should remove" do
        before do
          FactoryGirl.create(:core_course, :name => "algebra   2")
        end

        it "remove extra whitespaces" do
          course = CoreCourse.last
          course.name.should == "algebra 2"
        end
      end
    end
  end
end
