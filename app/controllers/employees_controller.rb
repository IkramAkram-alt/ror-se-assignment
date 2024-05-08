# app/controllers/employees_controller.rb
require 'net/http'
require 'net/https'
class EmployeesController < ApplicationController
  include ApiInteraction
  before_action :authenticate_user!

  def index
    @employees = fetch_all_employees(params[:page])
  end

  def edit
    @employee = fetch_employee(params[:id])
  end

  def show
    @employee = fetch_employee(params[:id])
  end

  def create
    @employee = create_employee(employee_params)
    redirect_to employee_path(@employee["id"])
  rescue ApiInteraction::ApiError => e
    flash[:error] = "Failed to create employee: #{e.message}"
    redirect_to new_employee_path
  end

  def update
    @employee = update_employee(params[:id], employee_params)
    redirect_to edit_employee_path(@employee["id"])
  rescue ApiInteraction::ApiError => e
    flash[:error] = "Failed to update employee: #{e.message}"
    redirect_to edit_employee_path(params[:id])
  end

  private

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end
end
