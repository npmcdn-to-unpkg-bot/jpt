class StudentprofilesController < ApplicationController
	before_action :authenticate_student!, except: [:index, :show]
	def index
		@studentprofiles = Studentprofile.all.order('created_at DESC')
		if params[:search]
			@studentprofiles = Studentprofile.search(params[:search]).order('created_at DESC')
		else 
			@studentprofiles = Studentprofile.all.order('created_at DESC')
		end 
	end  
	
	def new
		@studentprofile = Studentprofile.new
	end 

	
	def create
		@student = current_student
		@studentprofile = Studentprofile.new(studentprofile_params)
		if @studentprofile.save
			redirect_to studentprofilepage_path(@studentprofile), notice: "New profile created"
		else
			flash[:alert] = "There was a problem."
			render :new
		end 
	end 

	def show
		if current_student
			@studentprofile = current_student.studentprofile
		else 
			redirect_to root_path, notice: 'Please log in to view this page.'	
		end 
		@studentprofile = set_studentprofile
	end 

	def update
		set_studentprofile
		redirect_to studentprofile_path
	end 

	def edit
		set_studentprofile
		redirect_to studentprofile_path, alert: 'Profile edited'
	end 

	def destroy
		set_studentprofile
		@studentprofile.destroy
		redirect_to root_path, alert: 'Profile deleted.'
	end 

	private

	def set_studentprofile
		@studentprofile = Studentprofile.find(params[:id])
	end

	def studentprofile_params 
		params.require(:studentprofile).permit(:fname, :lname, :bio, :university, :zipcode, :planguage, :slanguage, :smoker, :allergies, :all_desc, :startduration, :endduration, :phone, :image).merge(student: current_student)
	end 

end
