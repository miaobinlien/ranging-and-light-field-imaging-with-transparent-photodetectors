classdef Camera
    properties
        arg = struct('nx', [], 'dx', [], 'ny', [], 'dy', [], ...
                     'nu', [], 'du', [], 'nv', [], 'dv', [], ...
                     'focalLen', [], 'apeSize', [], 'apeMask', [], ...
                     'focalStackDis', [], 'refDis', [], 'unit', 'mm', 'name', []);
    end
    methods
        % Constructor
        function obj = Camera(varargin)
            if nargin >= 1
                obj.arg = vararg_pair(obj.arg, varargin);
                parCheck(obj);

                if isempty(obj.arg.refDis)
                    obj.arg.refDis = max(obj.arg.focalStackDis);
                end

                [~, ~, u, v] = createAxes(obj);
                [U, V] = ndgrid(u, v);
                obj.arg.apeMask = ( U.^2 + V.^2 <= (obj.arg.apeSize/2)^2 );
            else
                error('Parameter(s) required');
            end
        end
        % Check if the parameters are valid
        function parCheck(obj)
            validateattributes( [obj.arg.nx obj.arg.ny obj.arg.nu obj.arg.nv], {'numeric'}, {'positive', 'integer'} );
            validateattributes( [obj.arg.dx obj.arg.dy obj.arg.du obj.arg.dv obj.arg.focalLen obj.arg.apeSize], {'numeric'}, {'positive'} );
            validateattributes( obj.arg.focalStackDis, {'numeric'}, {'vector', 'positive'} );
            if ~isempty(obj.arg.refDis), validateattributes(obj.arg.refDis, {'numeric'}, {'positive'}), end
            if ~isempty(obj.arg.name), validateattributes(obj.arg.name, {'char'}, {}), end
        end
        % Generate the row vector axes [x, y, u, v] from the camera parameters
        function [x, y, u, v] = createAxes(obj)
            x = obj.arg.dx*( -(obj.arg.nx-1)/2:1:(obj.arg.nx-1)/2 );
            y = obj.arg.dy*( -(obj.arg.ny-1)/2:1:(obj.arg.ny-1)/2 );
            u = obj.arg.du*( -(obj.arg.nu-1)/2:1:(obj.arg.nu-1)/2 );
            v = obj.arg.dv*( -(obj.arg.nv-1)/2:1:(obj.arg.nv-1)/2 );
        end
    end
end