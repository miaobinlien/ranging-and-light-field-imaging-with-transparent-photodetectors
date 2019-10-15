classdef FocalStack
    properties
        arg = struct('camera', [], 'focalStack', [], 'focalStackDis', [], 'name', []);
    end
    methods
        % Constructor
        function obj = FocalStack(varargin)
            if nargin == 6 || nargin == 8
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
            if ~isempty(obj.arg.focalStackDis)
                validateattributes(obj.arg.focalStackDis, {'numeric'}, {'vector', 'positive'});
            else
                error('1D focal stack distances required');
            end
            if ~isempty(obj.arg.focalStack)
                nF = size(obj.arg.focalStackDis, 2) > 1;
                validateattributes(obj.arg.focalStack, {'numeric'}, {'ndims', 2+nF});
            else
                error('3D focal stack required');
            end
            if size(obj.arg.focalStack, 3) ~= length(obj.arg.focalStackDis), error('# of focal stack sheets does not match # of focal stack distances'), end;
            if ~isempty(obj.arg.name), validateattributes(obj.arg.name, {'char'}, {}), end;
        end
        % Plot focal stack images
        function f = plotFS(obj)
            import utilities.imgDisplay;
            labelOn = false;

            cam = obj.arg.camera;
            [x, y, ~, ~] = cam.createAxes();

            fs = obj.arg.focalStack;
            fsd = obj.arg.focalStackDis;

            f = gobjects(1, length(fsd));
            for i = 1:length(fsd)
                f(i) = figure; imgDisplay( x, y, fs(:, :, i) );
                if labelOn
                    unit = cam.arg.unit;
                    if isempty(obj.arg.name)
                        name = '';
                    else
                        name = [obj.arg.name ': '];
                    end
                    xlabel(['x (' unit ')']); ylabel(['y (' unit ')']);
                    title([name 'Focal stack image at ' num2str(fsd(i)) ' (' unit ')']);
                end
            end
        end
    end
end
