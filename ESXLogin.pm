package ESXLogin;

use strict;

use XML::Simple qw(:strict);
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Headers;
use HTTP::Response;
use HTTP::Cookies;
use Data::Dumper;


my $VERSION = 0.1;


sub new   {
  my $class =shift  @_;
  my $self  = {};

   $self->{force_array}=0;
   $self->{soap_header}='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body>';
   $self->{soap_footer}='</soapenv:Body></soapenv:Envelope>';
   $self->{soap_action}='"urn:vim25/test"';
   $self->{namespace}="vim25";
  bless($self,$class);
  return $self;
  
 }


sub login {
	
     my ($self, $username, $password, $host, $opts) =  @_;
  	 my $body_content= "<_this type='SessionManager'>ha-sessionmgr</_this><userName>$username</userName><password>$password</password>";
  	 my $url;
     $host = "https://".$host unless ($host=~/^https?\:\/\//);
     $host.="/sdk" unless ($host=~/\/sdk$/);
    
    
  	  $self->{url}=$host;
	  my $request_envelope=$self->{soap_header}."<Login xmlns=\"urn:".$self->{namespace}."\">$body_content</Login>".$self->{soap_footer};

        if($$opts{force_array}) 
        {
	        $self->{force_array}=1;
	     }; 
        
   		  my $xml=$self->_request($request_envelope);
   		  my $val;  
   		if ($xml=~/^<\?xml/)
   		  {
        my $xs = XML::Simple->new();
        my $return= $xs->XMLin($xml, ForceArray=>$self->{force_array},KeyAttr=>0);
        my $faultval;
        my $successval;
        if($self ->{force_array})
           {
	         $faultval=$return->{'soapenv:Body'}->[0]->{'soapenv:Fault'}; #fault
        
       		if($faultval)
        	{$val= $faultval;}
      		else
      		{
	      		$successval= $return->{'soapenv:Body'}->[0]->{'LoginResponse'}->[0]->{'returnval'};
	      			if($successval)
        		{  
	        		$val= $successval;
        		}
      			   else
      		    { 
	      		   $val= $xml;
  			    }
	      	}
          }		
      		
      else
        {
	         $faultval=$return->{'soapenv:Body'}->{'soapenv:Fault'};;
        
       		if($faultval)
        	{
	            $val= $faultval;
      		}
      		
      		else
      		{
	      		$successval= $return->{'soapenv:Body'}->{'LoginResponse'}->{'returnval'};
	      			if($successval)
        		{
	       			    $val= $successval;
      			}
      			  else
      			    {
	      			    $val= $xml;
	      			    
      			    }
            }
	   }
	   
}
   else
   
      {
	   $val=$xml;   
      }
	return $val;
    }
    
  
sub logout {
	
	
	    my $self = shift;
  	    my $body_content= "<_this type='SessionManager'>ha-sessionmgr</_this>";
  	    my $request_envelope=$self->{soap_header}."<Logout xmlns=\"urn:".$self->{namespace}."\">$body_content</Logout>".$self->{soap_footer};

	    my $xml=$self->_request($request_envelope);
   		my $val;  
   		if ($xml=~/^<\?xml/)
   		  {
        my $xs = XML::Simple->new();
        my $return= $xs->XMLin($xml, ForceArray=>$self->{force_array},KeyAttr=>0);
        my $faultval;
        my $successval;
        if($self ->{force_array})
           {
	         $faultval=$return->{'soapenv:Body'}->[0]->{'soapenv:Fault'}; #fault
        
       		if($faultval)
        	{$val= $faultval;}
      		else
      		{
	      		$successval= $return->{'soapenv:Body'}->[0]->{'LoginResponse'}->[0]->{'returnval'};
	      			if($successval)
        		{  
	        		$val= $successval;
        		}
      			   else
      		    { 
	      		   $val= $xml;
  			    }
	      	}
          }		
      		
      else
        {
	         $faultval=$return->{'soapenv:Body'}->{'soapenv:Fault'};;
        
       		if($faultval)
        	{
	            $val= $faultval;
      		}
      		
      		else
      		{
	      		$successval= $return->{'soapenv:Body'}->{'LoginResponse'}->{'returnval'};
	      			if($successval)
        		{
	       			    $val= $successval;
      			}
      			  else
      			    {
	      			    $val= $xml;
	      			    
      			    }
            }
	   }
	   
}
   else
   
      {
	   $val=$xml;   
      }
	return $val;
	  
	
	
}    
sub discoverHost {
	
	 my $self= shift @_;
	 my $val;
	
	 my $body_content="<_this type='PropertyCollector'>ha-property-collector</_this><specSet><propSet><type>HostSystem</type><all>1</all></propSet><objectSet><obj type='HostSystem'>ha-host</obj></objectSet></specSet>";
	 my $request_envelope=$self->{soap_header}."<RetrieveProperties xmlns=\"urn:".$self->{namespace}."\">$body_content</RetrieveProperties>".$self->{soap_footer};
	 my $xml=$self->_request($request_envelope);
	 my $xs = XML::Simple->new();
     my $return= $xs->XMLin($xml, ForceArray=>$self->{force_array},KeyAttr=>0);
     my $faultval;
      
         if($self->{force_array})
         {
	         $faultval=$return->{'soapenv:Body'}->[0]->{'soapenv:Fault'}; #fault
        
       		if($faultval)
        	{
	            $val= $faultval;
      		}
      		else
      		{
	      		$val= $return->{'soapenv:Body'}->[0]->{'RetrievePropertiesResponse'}->[0]->{'returnval'};
	      	}
      		
        }		
      		
      else
        {
	         $faultval=$return->{'soapenv:Body'}->{'soapenv:Fault'};
       		if($faultval)
        	{
	       		$val= $faultval;
      		}
      		else
      		{
	           $val= $return->{'soapenv:Body'}->{'RetrievePropertiesResponse'}->{'returnval'};
            }
	   }
	   
	return $val;
	
	
}
  

sub discoverVM    {
	
	my $self= shift @_;
	my $val;
	my $ret=$self->_retrieveProperties();
	
	my $start_body_content="<_this type='PropertyCollector'>ha-property-collector</_this><specSet><propSet><type>VirtualMachine</type><all>1</all></propSet>";
	my $main_body_content="";
	my $end_body_content="</specSet>";
	
	
	foreach my $hash (@$ret)
	   {
		   my $id=$hash->{obj}->{content};
		   $main_body_content.="<objectSet><obj type='VirtualMachine'>$id</obj></objectSet>";
	   }
	 
	  my $body_content=$start_body_content.$main_body_content.$end_body_content;
	  my $request_envelope=$self->{soap_header}."<RetrieveProperties xmlns=\"urn:".$self->{namespace}."\">$body_content</RetrieveProperties>".$self->{soap_footer};;

  	  my $xml=$self->_request($request_envelope);
  	
  	  my $xs = XML::Simple->new();
      my $return= $xs->XMLin($xml, ForceArray=>$self->{force_array},KeyAttr=>0);
      my $faultval;
      
         if($self->{force_array})
         {
	         $faultval=$return->{'soapenv:Body'}->[0]->{'soapenv:Fault'}; #fault
        
       		if($faultval)
        	{
	            $val= $faultval;
      		}
      		else
      		{
	      		$val= $return->{'soapenv:Body'}->[0]->{'RetrievePropertiesResponse'}->[0]->{'returnval'};
	      	}
      		
        }		
      		
      else
        {
	         $faultval=$return->{'soapenv:Body'}->{'soapenv:Fault'};
       		if($faultval)
        	{
	       		$val= $faultval;
      		}
      		else
      		{
	           $val= $return->{'soapenv:Body'}->{'RetrievePropertiesResponse'}->{'returnval'};
            }
	   }
	   
	return $val;
	
}




sub _retrieveProperties  {
	    my $self= shift @_;
		my $body_content= "<_this type='PropertyCollector'>ha-property-collector</_this><specSet><propSet><type>VirtualMachine</type><all>0</all></propSet><objectSet><obj type='Folder'>ha-folder-root</obj><skip>0</skip><selectSet xsi:type='TraversalSpec'><name>folderTraversalSpec</name><type>Folder</type><path>childEntity</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet><selectSet><name>datacenterHostTraversalSpec</name></selectSet><selectSet><name>datacenterVmTraversalSpec</name></selectSet><selectSet><name>datacenterDatastoreTraversalSpec</name></selectSet><selectSet><name>datacenterNetworkTraversalSpec</name></selectSet><selectSet><name>computeResourceRpTraversalSpec</name></selectSet><selectSet><name>computeResourceHostTraversalSpec</name></selectSet><selectSet><name>hostVmTraversalSpec</name></selectSet><selectSet><name>resourcePoolVmTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>datacenterDatastoreTraversalSpec</name><type>Datacenter</type><path>datastoreFolder</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>datacenterNetworkTraversalSpec</name><type>Datacenter</type><path>networkFolder</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>datacenterVmTraversalSpec</name><type>Datacenter</type><path>vmFolder</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>datacenterHostTraversalSpec</name><type>Datacenter</type><path>hostFolder</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>computeResourceHostTraversalSpec</name><type>ComputeResource</type><path>host</path><skip>0</skip></selectSet><selectSet xsi:type='TraversalSpec'><name>computeResourceRpTraversalSpec</name><type>ComputeResource</type><path>resourcePool</path><skip>0</skip><selectSet><name>resourcePoolTraversalSpec</name></selectSet><selectSet><name>resourcePoolVmTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>resourcePoolTraversalSpec</name><type>ResourcePool</type><path>resourcePool</path><skip>0</skip><selectSet><name>resourcePoolTraversalSpec</name></selectSet><selectSet><name>resourcePoolVmTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>hostVmTraversalSpec</name><type>HostSystem</type><path>vm</path><skip>0</skip><selectSet><name>folderTraversalSpec</name></selectSet></selectSet><selectSet xsi:type='TraversalSpec'><name>resourcePoolVmTraversalSpec</name><type>ResourcePool</type><path>vm</path><skip>0</skip></selectSet></objectSet></specSet>";
  	
 
     my $request_envelope=$self->{soap_header}."<RetrieveProperties xmlns=\"urn:".$self->{namespace}."\">$body_content</RetrieveProperties>".$self->{soap_footer};;
 	 my $xml=$self->_request($request_envelope);
  	 my $xs = XML::Simple->new();
     my $return= $xs->XMLin($xml, ForceArray=>0,KeyAttr=>0);
     my $faultval=$return->{'soapenv:Body'}->{'soapenv:Fault'};
     if ($faultval)
     {
	     return $faultval;
	 }
     else
     {
	     return $return->{'soapenv:Body'}->{'RetrievePropertiesResponse'}->{'returnval'};
     }
	 
 }
	

sub _request  {
	
	my ($self,$request_envelope)=@_;
	my $test;
  
	# http header
   my $http_header = HTTP::Headers->new(
                        Content_Type => 'text/xml',
                        SOAPAction => $self->{soap_action},
                        Content_Length => byte_length($request_envelope));
   # request
   my $request = HTTP::Request->new('POST',
                                    $self->{url},
                                    $http_header,
                                    $request_envelope);
                                    
    unless($self->{user_agent})
     {
		my $ua = LWP::UserAgent->new;
		$ua->ssl_opts( verify_hostname => 0,SSL_verify_mode=>0);
		$ua->protocols_allowed( ['http', 'https'] );
		$self->{user_agent}=$ua;
		$self->{cookie_jar}= HTTP::Cookies->new(ignore_discard => 1);
        $self->{user_agent}->cookie_jar($self->{cookie_jar});               
	 
     }
    
	             
   
              
   my $response = $self->{user_agent}->request($request);
   my $xml= $response->content();
   return $xml;
	
 }

sub byte_length {
    my ($string) = @_;
    use bytes;
    return length($string);
}

1;
	


=head1 NAME

Sample - a sample script indicating the format of a single-file
script upload to CPAN

=head1 DESCRIPTION

Login to VMWare ESX server and discover the Virtual Machines therein

=head1 README

If there is any text in this section, it will be extracted into
a separate README file.

=head1 PREREQUISITES


=head1 COREQUISITES

=pod OSNAMES

any

=pod SCRIPT CATEGORIES

CPAN/Administrative
Fun/Educational

=cut

