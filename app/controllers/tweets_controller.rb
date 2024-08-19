class TweetsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]
    

    def index
        @tweets = Tweet.all
    end

    def new
        @tweet = Tweet.new
    end

    def job

    end

    def dog
        
    end

    def cat
        
    end

    def apple
        
    end
    
    def create
        tweet = Tweet.new(tweet_params)
        tweet.user_id = current_user.id
        if tweet.save!
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
    end

    def show
        @tweet = Tweet.find(params[:id])
        @comments = @tweet.comments
        @comment = Comment.new
    end

    def top 
    end

 
    private
    def tweet_params
        params.require(:tweet).permit(:body, :title, :overall)
    end

end
