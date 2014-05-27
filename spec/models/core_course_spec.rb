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
end
