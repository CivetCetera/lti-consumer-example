class ToolConsumersController < ApplicationController

  def index
  end

  def tool_launch
  tc = IMS::LTI::ToolConfig.new(:title => params['tool_name'], :launch_url => params['launch_url'])
  @consumer = IMS::LTI::ToolConsumer.new(params['consumer_key'], params['consumer_secret'])
  @consumer.set_config(tc)

  host = request.scheme + "://" + request.host_with_port

  # Set some launch data from: http://www.imsglobal.org/LTI/v1p1pd/ltiIMGv1p1pd.html#_Toc309649684
  # Only this first one is required, the rest are recommended
  @consumer.resource_link_id = "thisisuniquetome"
  @consumer.launch_presentation_return_url = host + '/tool_return'
  @consumer.lis_person_name_given = params['username']
  @consumer.user_id = Digest::MD5.hexdigest(params['username'])
  @consumer.roles = "learner"
  @consumer.context_id = "bestcourseever"
  @consumer.context_title = "Example Tool Consumer"
  @consumer.tool_consumer_instance_name = "LMS"

  if params['assignment']
    @consumer.lis_outcome_service_url = host + '/grade_passback'
    @consumer.lis_result_sourcedid = "oi"
  end

  @autolaunch = !!params['autolaunch']

  render "tool_launch"
end

end
