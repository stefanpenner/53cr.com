Apparently trying to assign a datetime_select as a virtual attribute in Rails doesn’t work correctly. Instead of rendering the following code, which I would assume is the correct behaviour:

[code=ruby]
team[member_attributes][][arrival(5i)]
[/code]

It renders this:

[code=ruby]
team[member_attributes][arrival(5i)]
[/code]

For example, when creating a new team model, one can also create N new member models from the same form, where a member is associated with a team.

[code=ruby]
# teams/new.html.haml
-form_for([@team]) do |f| 
  = link_to_function 'Add a Member' { |page| page.insert_html :bottom, :members, :partial => 'member', :object => Member.new } 
  = f.submit 
 
# teams/_member.html.haml
- fields_for 'team[member_attributes][]', member do |f| 
= f.datetime_select  :arrival 
 
# teams_controller.rb
def create 
  @team = Team.new(params[:team]) 
  @members = @team.members 
end 
 
# models/team.rb
def member_attributes=(attributes) 
  attributes.each do |a| 
    members.build(a) 
  end 
end
[/code]

When this form is submitted, the following error is thrown.

[code=plain_text]
## Error 
Status: 500 Internal Server Error 
Conflicting types for parameter containers. Expected an instance of
Hash but found an instance of Array. This can be caused by colliding
Array and Hash parameters like qs[]=value&qs[key]=value. (The
parameters received were [{"attribute"=>""}].)
[/code]

Walking through the code with the debugger, it turns out this snippet of code in the rails source may be the culprit:

[code=ruby]
#rails/actionpack/lib/action_view/helpers/form_helper.rb:508
if @object_name.sub!(/\[\]$/,'') 
  if object ||= @template_object.instance_variable_get("@#{Regexp.last_match.pre_match}") and object.respond_to?(:to_param) 
    @auto_index = object.to_param 
  else 
    raise ArgumentError, "object[] naming but object param and @object var don't exist or don't respond to to_param: #{object.inspect}" 
 end 
end
[/code]

It seems to explicitly remove empty [] tags on datetime_select. This seems to be more of a feature than a bug, so I tried to adapt my code to work with it, which resulted in:

[code=ruby]
# teams/new.html.haml
-form_for([@team]) do |f| 
 
... 
 
%p= link_to_function "Add a Member"; do |page| 
  page.insert_html :bottom, :members, :partial =>'member', :object => Member.new 
  = f.submit 
 
# teams/_member.html.haml
- fields_for "team[member_attributes][bar]", member do |f| 
  = f.datetime_select  :arrival 
  
# teams_controller.rb
def create 
  @team = Team.new(params[:team]) 
  @members = @team.members 
end 
 
# models/team.rb
def member_attributes=(attributes) 
  [attributes["fu"]].each do |a| 
    members.build(a) 
  end 
end
[/code]

As you can see, two small changes fixed the problem:

1. fields_for “team[member_attributes][fu]” instead of an empty []
2. in models/team.rb iterate over all the attributes inside attributes["fu"] instead of just iterating over attributes
