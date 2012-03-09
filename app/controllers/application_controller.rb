class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all
end
