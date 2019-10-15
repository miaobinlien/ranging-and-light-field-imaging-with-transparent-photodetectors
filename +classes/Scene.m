classdef Scene
    properties
        arg = struct('objects', [], 'positions', [], 'name', []);
    end
    methods
        % Constructor
        function obj = Scene(varargin)
            if nargin >= 1
                obj.arg = vararg_pair(obj.arg, varargin);
                parCheck(obj);
            else
                error('Parameter(s) required');
            end
        end
        % Check if the parameters are valid
        function parCheck(obj)
            cellfun( @(object) validateattributes(object, {'function_handle'}, {'ndims', 2}), obj.arg.objects );
            cellfun( @(position) validateattributes(position, {'numeric'}, {'size', [1, 3]}), obj.arg.positions );
            if length(obj.arg.objects) ~= length(obj.arg.positions), error('Number of Objects and Positions do not match'), end
            if ~isempty(obj.arg.name), validateattributes(obj.arg.name, {'char'}, {}), end
        end
    end
end