module Puppet::Parser::Functions
    newfunction(:postfix_resources, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
        This function will make all the parameters declared for the postfix module (Thias) to be
    set as well formed hash values so that create_resources on them will convert it to the 
    required resources 
    I.e
    given these parameters in declaration
    {
        myhostname              => 'gideon.vnet.com',
        mydomain                => 'vnet.com',
        mydestination           => "\$myhostname, localhost.\$mydomain, localhost, $fqdn",
        inet_interfaces         => 'all',
        message_size_limit      => '15360000', # 15MB
        mail_name               => 'example mail daemon',
        virtual_mailbox_domains => [
          'proxy:mysql:/etc/postfix/mysql_virtual_domains_maps.cf',
        ],
      }
        Will result to the following final hash that create_resources can be called on 
        (THIS WILL EXCLUDE ALL THE HASH VALUES AND RETURN ON THE SINGLE KEY VALUE ELEMENTS ONLY)
        RESULT = {
          myhostname => {
          ensure => present,
          value  => 'gideon.vnet.com',
          },
          mydomain => {
          ensure => present,
          value  => 'vnet.com',
          }
          inet_interfaces => {
          ensure  => present,
          value   => 'all',
          }
          mail_name => {
          ensure  => present,
          value   => 'example mail daemon',
          }
          ...(continuation)
        }

   ENDHEREDOC
     #Check that we have at least one argument
     if args.length < 1
       raise Puppet::ParseError,("postfix_resources: Expects an argument")
     end

     
      many_options = args[0]
      unless many_options.is_a?(Hash)
       raise Puppet::ParseError,("postfix_resources: The argument must be a hash provided")
     end
     

    def postfix_hash (options)
      options.each {|key, value|
        if (value.is_a?(String))
          #Create a new hash
          newhash = Hash.new
          newhash[key] = { "ensure" => "present", "value" => value }
          return newhash
        end#end if 
      }
    end#end def function
    postfix_hash(many_options)
 end
end
