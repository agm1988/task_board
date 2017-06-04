module NotificationsMailerHelper
  def comment_url_with_anchor(comment)
    anchor = "comment_#{comment.id}"
    commentable = comment.commentable

    case commentable
      when Report
        report_url(commentable, anchor: anchor)
      when Task
        task_url(commentable, anchor: anchor)
    end
  end
end
