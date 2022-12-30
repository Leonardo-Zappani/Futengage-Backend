# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :ensure_frame_response, only: %i[new edit]
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts or /contacts.json
  def index
    authorize! :read, Contact

    query = current_account.contacts.with_attached_avatar.sort_by_params(sort_column(Contact, default: :first_name),
                                                                         sort_direction)
    query = query.search_by_q(params[:q]) if params[:q].present?
    if params[:contact_type].present?
      query = query.where(contact_type_cd: Contact.contact_types[params[:contact_type].to_sym])
    end

    @pagy, @records = pagy(query)

    @records.load
  end

  # GET /contacts/1 or /contacts/1.json
  def show; end

  # GET /contacts/new
  def new
    authorize! :create, Contact

    @contact = Contact.new(contact_type: params[:contact_type])
  end

  # GET /contacts/1/edit
  def edit; end

  # POST /contacts or /contacts.json
  def create
    authorize! :create, Contact

    @contact = current_account.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        notice = t('.success')
        format.html { redirect_to contacts_url(contact_type: @contact.contact_type), notice: }
        format.json { render :show, status: :created, location: @contact }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    authorize! :update, Contact

    respond_to do |format|
      if @contact.update(contact_params)
        notice = t('.success')
        format.html { redirect_to contacts_url(contact_type: @contact.contact_type), notice: }
        format.json { render :show, status: :ok, location: @contact }
        format.turbo_stream { flash.now.notice = notice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    authorize! :destroy, Contact

    @contact.destroy_or_discard
    respond_to do |format|
      notice = t('.success')
      format.html { redirect_to contacts_url, notice: }
      format.json { head :no_content }
      format.turbo_stream { flash.now.notice = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = current_account.contacts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:person_type, :contact_type, :name, :document_1, :document_2, :email,
                                    :phone_number, :description, :avatar)
  end
end
