class Link < ApplicationRecord
  belongs_to :user

  has_many :comments
  has_many :votes

  validates :title,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :url,
            format: { with: %r{\Ahttps?://} },
            allow_blank: true

  scope :hottest, -> { order(hot_score: :desc)}
  scope :newest, -> { order(created_at: :desc)}

  def comment_count
    comments.length
  end

  def upvotes
    votes.sum(:upvote)
  end

  def downvotes
    votes.sum(:downvote)
  end

  # The hot score of a link will be based on a time decay algorithm and how this works is fairly simple, a time decay algorithm will reduce the value of a number based on the time (in hours) and gravity (an arbitrary number). What this means is that as a link gets older, it's hot score will start to drop and it's ranking affected.

  # This ensures that old links with a lot of points don't continually stay at the top of the ranking but will at some point drop and this will ensure that newer threads with not as much points get a fair ranking as well.

  def calc_hot_score
    points = upvotes - downvotes
    time_ago_in_hours = ((Time.now - created_at) / 3600).round
    score = hot_score(points, time_ago_in_hours)

    update_attributes(points: points, hot_score: score)
  end

  private
  def hot_score(points, time_ago_in_hours, gravity = 1.8)
    # one is subtracted from available points because every link by default has one point
    # There is no reason for picking 1.8 as gravity, just an arbitrary value
    (points - 1) / (time_ago_in_hours + 2) ** gravity
  end
end
