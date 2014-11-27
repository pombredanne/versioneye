class User::CollaborationsController < ApplicationController

  before_filter :authenticate

  def index
    collaborations = ProjectCollaborator.by_user(current_user)
    @projects = []
    collaborations.each do |collab|
      if collab.project
        @projects << collab.project
      else
        Rails.logger.error "Collaborated project doesnt exists: `#{collab.to_json}`"
        collab.remove
      end
    end
  end

  def show
    collab_id = params[:id]

    @collaboration = ProjectCollaborator.find_by_id(collab_id)
    if @collaboration.nil? or !@collaboration.current?(current_user)
      flash[:error] = 'Wrong collaboration, or this collaboration is now remove.'
      render text: 'Contributions doesnt exist anymore.', layout: 'application'
    end
  end

  def delete
    collab_id = params[:id]
    collab_id ||= params[:collaboration_id]

    collaborator = ProjectCollaborator.find_by_id(collab_id)
    if collaborator.nil?
      flash[:error] = 'No such collaborator anymore.'
      redirect_to :back and return
    end

    url = "/user/projects/#{collaborator.project.id.to_s}#tab-collaborators"
    url = "/user/collaborations" if !collaborator.owner_id.to_s.eql?( current_user.id.to_s )
    user_id = current_user.id
    if collaborator.owner.id != user_id && collaborator.user.id != user_id
      flash[:error] = 'You can not remove this.'
      redirect_to( url ) and return
    end

    flash[:success] = 'Collaborator is now removed.'
    collaborator.delete
    redirect_to( url ) and return
  end

  def approve
    collab_id = params[:id]
    collab_id ||= params[:collaboration_id]

    collab = ProjectCollaborator.find_by_id(collab_id)

    if collab.user_id.to_s.eql?( current_user.id.to_s ) || collab.invitation_email.eql?( current_user.email )
      collab.active = true
      collab.user_id = current_user[:_id].to_s
      collab.invitation_email = current_user[:email]
      collab.save
      flash[:success] = 'Thanks for approving.'
    else
      flash[:error] = "It seems you don't have access to this project. Contact the VersionEye Team if you think that's wrong."
    end

    redirect_to :back
  end

  def save_period
    id = params[:collaboration_id]
    period = params[:period]
    @collab = ProjectCollaborator.find_by_id(id)
    @collab.update_attributes({period: period})
    if @collab.save
      flash[:success] = 'Status saved.'
    end
    redirect_to :back
  end

  def save_email
    id       = params[:collaboration_id]
    email    = params[:email]
    @collab = ProjectCollaborator.find_by_id(id)

    new_email  = nil
    user       = current_user
    user_email = user.get_email(email)
    new_email  = user_email.email if user_email
    new_email  = user.email unless user_email

    @collab.update_attributes({email: new_email})
    if @collab.save
      flash[:success] = 'Status saved.'
    else
      flash[:error] = 'Something went wrong. Please try again later.'
    end
    redirect_to user_collaboration_path(@collab)
  end


end
