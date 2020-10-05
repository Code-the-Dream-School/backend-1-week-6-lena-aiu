require "sinatra"
require "uri"

set :bind, "0.0.0.0"

enable :sessions

get "/" do
    if session[:secret_number].nil?
        session[:secret_number] = rand(100)
    end
    erb :game
end 

get '/won' do
    erb :won
end

get '/lost' do
    erb :lost
end

post '/reset' do
    session[:bgcolor] = ""
    session[:secret_number] = nil
    session[:mistake] = nil
    session[:attempts] = []
    redirect '/'
end

post '/guess' do

        if session[:secret_number].nil?
          redirect '/'
        end
    
        session[:attempts] ||= []
        session[:counter] = 1
        session[:max_counter] = 7

        session[:attempts] << params[:user_guess].to_i

        if   session[:attempts].last == session[:secret_number]
            redirect '/won'
            break
        end    
        while session[:counter] <= session[:max_counter] && session[:attempts].last != session[:secret_number]   
            if  session[:attempts] == session[:secret_number]
                redirect '/won'
                break
            elsif session[:attempts].last > session[:secret_number]
                diff = session[:attempts].last - session[:secret_number]
                if diff <= 10
                    session[:mistake] = "You guess is high"
                    session[:bgcolor] = "orange"
                    break
                else diff > 10
                    session[:mistake] = "You guess is way too high"
                    session[:bgcolor] = "yellow"
                    break
                end
            elsif session[:attempts].last < session[:secret_number]
                diff = session[:secret_number] - session[:attempts].last
                if diff <= 10
                    session[:mistake] = "Your guess is low"
                    session[:bgcolor] = "green"
                    break
                else diff > 10
                    session[:mistake] = "Your guess is way too low"
                    session[:bgcolor] = "blue"
                    break
                end
            end            
            session[:counter] += 1
        end       
    redirect '/'
end   