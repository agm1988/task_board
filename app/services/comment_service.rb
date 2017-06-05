# frozen_string_literal: true

class CommentService
  def self.run(commentable:, author:, comment:)
    # TODO: try to rewrite this
    report = case commentable
             when Report
               commentable
             when Task
               commentable.report
             end

    flag = !report.draft?

    comment = commentable.comments.new(user_id: author.id, body: comment, need_notification: flag)

    if comment.save
      ::Maybe::Some.new(comment)
    else
      ::Maybe::None.new(comment)
    end
  end
end
