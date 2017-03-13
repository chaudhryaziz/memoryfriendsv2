class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

#enforce username logged in session to prevent direct access of URL and unique usernames
   validates_presence_of :username
   validates_uniqueness_of :username

#This defines the different releationships between friends, posts, and inverse_friendships which is used for Friendship requests.
   has_many :friendships, dependent: :destroy
   has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy 
   has_many :posts, dependent: :destroy

   #request a friendship with another user
   def request_friendship(user_2)
   	self.friendships.create(friend: user_2)
   end

   #When friend has requested a friendship to you but you have yet to respond. 
   def pending_friend_requests_from
   	self.inverse_friendships.where(state: "pending")
   end
   #When You request a friendship with someone else but they have yet to respond
   def pending_friend_requests_to
   	self.friendships.where(state: "pending")
   end

   #List all your current friends
   def active_friends
   	self.friendships.where(state: "active").map(&:friend) + self.inverse_friendships.where(state: "active").map(&:user)
   end
   #Display the relationship you have with iths person when you view their profile page
   def friendship_status(user_2)
    friendship = Friendship.where(user_id: [self.id,user_2.id], friend_id: [self.id,user_2.id])
    unless friendship.any?
      return "not_friends"
    else
      if friendship.first.state == "active"
        return "friends"
      else
      if friendship.first.user == self
        return "pending"
      else
        return "requested"
      end
      end
      end
   end
   #compute current relationship with friend to display the appropriate relationship in the page. 
   def friendship_relation(user_2)
    Friendship.where(user_id: [self.id,user_2.id], friend_id: [self.id,user_2.id]).first
   end

end
