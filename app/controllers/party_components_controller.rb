class PartyComponentsController < ApplicationController
  before_action :set_party
  before_action :set_party_component, only: [:destroy]

  def index
    @inventory = filtered_party_components
  end

  def new
    set_filter_options
    @components = filtered_components
    @party_component = @party.party_components.new
  end

  def create
    @party_component = @party.party_components.new(party_component_params)
    if @party_component.save
      @inventory = filtered_party_components
      redirect_to party_party_components_path(@party), notice: "Component added to inventory."
    else
      set_filter_options
      @components = filtered_components
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @party_component.destroy
    redirect_to party_party_components_path(@party), notice: "Component removed from inventory."
  end

  private

    def set_party
      @party = Party.find(params[:party_id])
    end

    def set_party_component
      @party_component = @party.party_components.find(params[:id])
    end

    def party_component_params
      params.require(:party_component).permit(:component_id, :quantity, :metatags)
    end

    def set_filter_options
      @monster_types = Component.monster_type_options
      @component_types = Component.component_type_options
      @selected_monster_type = params[:monster_type] || (params[:party_component] && params[:party_component][:monster_type])
      @selected_component_type = params[:component_type] || (params[:party_component] && params[:party_component][:component_type])
    end

    def filtered_components
      components = Component.all
      components = components.where(monster_type: @selected_monster_type) if @selected_monster_type.present?
      components = components.where(component_type: @selected_component_type) if @selected_component_type.present?
      components.page(params[:page]).per(20)
    end

    def filtered_party_components
      @party.party_components.includes(:component)
    end
end
