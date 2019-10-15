% setup.m
% run this file to set up matlab path etc.
% you may need to modify this depending on how you installed the toolbox
% so this should be considered simply a "guide" not a robust script.

if ~exist('irtdir', 'var')
	disp('The variable "irtdir" is not set, so trying default, assuming')
	disp('that you launched matlab from the irt install directory.')
	disp('You may need to edit setup.m or adjust your path otherwise.')

%	irtdir = pwd; % the default is to assume launch from irt directory

	% default is to look for directory where this setup.m is installed!
	irtdir = which('setup'); % find setup.m
	[irtdir dummy] = fileparts(irtdir);
	clear dummy

	disp(['Assuming you installed irt in directory "' irtdir '".'])

%	irtdir = '~fessler/l/src/matlab/alg/'; % where you install this package
%	irtdir = '~fessler/l/web/irt/'; % where you install this package
end

if ~exist(irtdir, 'dir')
	disp(sprintf('The directory "%s" does not exist', irtdir))
	error(sprintf('you need to edit %s to change default path', mfilename))
end

if irtdir(end) ~= filesep % make sure there is a '/' at end of directory
	irtdir = [irtdir filesep];
end

addpath([irtdir 'systems']);		% system "matrices"
addpath([irtdir 'systems/tests']);	% tests of systems

tmp = [irtdir 'um']; % extra files for um users only
if exist(tmp, 'dir'), addpath(tmp), end
tmp = [irtdir 'um/lustig-poisson-disk'];
if exist(tmp, 'dir'), addpath(tmp), end

if ir_is_octave
	addpath([irtdir 'octave']); % extra stuff for octave only!
elseif isempty(which('dbstack')) % for freemat only!
	addpath([irtdir 'freemat']); % extra stuff for freemat only!
end
