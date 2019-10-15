classdef Lightfield
    properties
        arg = struct('camera', [], 'lightfield', [], 'name', []);
    end
    methods
        % Constructor
        function obj = Lightfield(varargin)
            if nargin == 4 || nargin == 6
                obj.arg = vararg_pair(obj.arg, varargin);
                parCheck(obj);
            else
                error('Incorrecr number of parameters');
            end
        end
        % Check if the parameters are valid
        function parCheck(obj)
            if ~isempty(obj.arg.camera)
                validateattributes(obj.arg.camera, {'classes.Camera'}, {});
            else
                error('Camera object required');
            end
            if ~isempty(obj.arg.lightfield)
                validateattributes(obj.arg.lightfield, {'numeric'}, {'ndims', 4});
            else
                error('4D lightfield required');
            end
            if ~isempty(obj.arg.name), validateattributes(obj.arg.name, {'char'}, {}), end;
        end
        % Plot intensity image
        function f = plotImg(obj)
            import utilities.imgDisplay;

            cam = obj.arg.camera;
            [x, y, ~, ~] = cam.createAxes();
            unit = cam.arg.unit;

            if isempty(obj.arg.name)
                name = '';
            else
                name = [obj.arg.name ': '];
            end

            f = figure; imgDisplay( x, y, sum(sum(obj.arg.lightfield, 3), 4) );
            xlabel(['x (' unit ')']); ylabel(['y (' unit ')']);
            title([name 'Intensity image at the last focal stack sheet']);
        end
        % Plot epipolar image
        function f = plotEpi(obj, varargin)
            import utilities.imgDisplay;
            position = struct('x', [], 'y', [], 'u', [], 'v', []);
            position = vararg_pair(position, varargin);

            nElements = length( fieldnames(position) );
            nEmptyElements = sum( structfun(@isempty, position) );
            if nElements ~= 4
                error('The correct number of total parameters x, y, u, v is 4');
            elseif nEmptyElements ~= 2
                error('The correct number of epipolar parameters x-u or y-v is 2');
            end

            cam = obj.arg.camera;
            index = pos2index(cam, position);
            [x, y, u, v] = cam.createAxes();
            unit = cam.arg.unit;

            if isempty(obj.arg.name)
                name = '';
            else
                name = [obj.arg.name ': '];
            end

            lf = obj.arg.lightfield;
            if ~isempty(position.x) && ~isempty(position.u)
                img = squeeze( lf(index(1), :, index(2), :) );
                f = figure; imgDisplay(y, v, img);
                xlabel(['y (' unit ')']); ylabel(['v (' unit ')']);
                title([name 'y-v Epipolar plot at (x, u) = (' num2str(position.x) ', ' num2str(position.u) ')']);
            elseif ~isempty(position.y) && ~isempty(position.v)
                img = squeeze( lf(:, index(1), :, index(2)) );
                f = figure; imgDisplay(x, u, img);
                xlabel(['x (' unit ')']); ylabel(['u (' unit ')']);
                title([name 'x-u Epipolar plot at (y, v) = (' num2str(position.y) ', ' num2str(position.v) ')']);
            else
                error('Incorrect matching between x-u or y-v axes');
            end
        end
    end
end

%% Convert Position to the Corresponding Index in lf(i, j, k, l)
function index = pos2index(cam, position)
    index = [];
    if ~isempty(position.x)
        nx = cam.arg.nx; dX = cam.arg.dX;
        ix = (nx+1)/2 + position.x/dX;
        index = [index, ix];
    end
    if ~isempty(position.y)
        ny = cam.arg.ny; dy = cam.arg.dy;
        iy = (ny+1)/2 + position.y/dy;
        index = [index, iy];
    end
    if ~isempty(position.u)
        nu = cam.arg.nu; du = cam.arg.du;
        iu = (nu+1)/2 + position.u/du;
        index = [index, iu];
    end
    if ~isempty(position.v)
        nv = cam.arg.nv; dv = cam.arg.dv;
        iv = (nv+1)/2 + position.v/dv;
        index = [index, iv];
    end
    index = round(index);
end
