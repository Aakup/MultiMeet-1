class RankingsController < ApplicationController
  before_action :set_fields, only: [:show, :edit, :update, :destroy]

  # GET /rankings
  # GET /rankings.json
  def index
    @rankings = Ranking.all
  end

  # GET /rankings/1
  # GET /rankings/1.json
  def show
  end

  # GET /rankings/new
  def new
    @ranking = Ranking.new
  end

  # GET /rankings/1/edit
  def edit
    @participant = Participant.find_by(project_id: params[:project_id], id: params[:participant_id])
    if params[:secret_id] != @participant.secret_id
      flash[:message] = "INVALID LINK"
    else
      flash[:message] = "VALID LINK"
    end
  end

  def submit_preference

  end

  # POST /rankings
  # POST /rankings.json
  def create
    @ranking = Ranking.new(ranking_params)

    respond_to do |format|
      if @ranking.save
        format.html { redirect_to @ranking, notice: 'Ranking was successfully created.' }
        format.json { render :show, status: :created, location: @ranking }
      else
        format.html { render :new }
        format.json { render json: @ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # def parse_rank id
  #   if params[id].eql? 'preferred'
  #     1
  #   elsif params[id].eql? 'okay'
  #     2
  #   else
  #     3
  #   end
  # end

  # PATCH/PUT /rankings/1
  # PATCH/PUT /rankings/1.json
  def update
    # respond_to do |format|
    #   if @ranking.update(ranking_params)
    #     format.html { redirect_to @ranking, notice: 'Ranking was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @ranking }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @ranking.errors, status: :unprocessable_entity }
    #   end
    # end

    @times.ids.each do |id|
      # byebug
      rank_num = params[id.to_s].to_i
      new_rank = Ranking.new(:id => @ranking.id, :rank => rank_num, :participant_id => @participant.id, :project_time_id => id)
      existing_rank = Ranking.find_by(:id => @ranking.id, :project_time_id => id)

      if existing_rank
        existing_rank.destroy
        new_rank.save!
        # flash[:message] = "Participant's email already exists"
        # redirect_to display_project_participants_path(params[:project_id])
      else @participant.save!
        # flash[:success] = "Successfully created participant #{@participant.email}"
        # redirect_to display_project_participants_path(params[:project_id])
      end
    end

    redirect_to end_project_participant_ranking_path

    # params[@times]
    # Ranking.create()
  end

  # DELETE /rankings/1
  # DELETE /rankings/1.json
  def destroy
    @ranking.destroy
    respond_to do |format|
      format.html { redirect_to rankings_url, notice: 'Ranking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fields
      @project = Project.find(params[:project_id])
      @ranking = Ranking.find(params[:participant_id])
      @participant = Participant.find_by(:project_id => params[:project_id], :id => params[:participant_id])
      @times = @project.project_times
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ranking_params
      params.fetch(:ranking, {})
    end
end
