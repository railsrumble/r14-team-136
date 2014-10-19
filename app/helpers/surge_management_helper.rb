module SurgeManagementHelper
  def add_tree(node)

    str = []
    node[:children] = node[:children].reject{|x| x == Object}
 
  tmp = []
 
  spaces = "()" * (node[:children].count / 2)

  unless node[:children].blank?
    
    tmp <<  "(" + node[:base_class].downcase.gsub(":", "_") + ":" +  node[:base_class].gsub(":", "_")
    s = node[:children].collect{|x| x[:base_class].to_s.classify.downcase.gsub(":", "_")}.uniq.join(",")

    p s 
    tmp << ">  [ " +  s  + "  ]) ||"

    node[:children].each_with_index do |child, index|
 
	tmp2 =  "(" + child[:base_class].downcase.gsub(":", "_") + ":" +  child[:base_class].gsub(":", "_")
	tmp += [ (tmp2 +  ") ||")  ]
 
    end

    str += [spaces , tmp]
  else
    tmp <<   "(" + node[:base_class].downcase.gsub(":", "_") + ":" +  node[:base_class].gsub(":", "_") + ")"
    str += [spaces , tmp]
  end




  p node[:base_class].downcase
  str.join(" ")
  end
end
