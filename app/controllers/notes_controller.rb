class NotesController < ApplicationController
   # skip_before_action :verify_authenticity_token
   def create
      @note = Note.create(note_params)
      flash[:info] = "Note successfully added"
      render json: @note
   end

   def destroy
      @note = Note.find(params[:id])
      @note.destroy
      flash[:info] = "Note successfully removed"
      head :no_content
   end

   private
   def note_params
      params.require(:note).permit(:jira_number, :body, :build_id)
   end
end
