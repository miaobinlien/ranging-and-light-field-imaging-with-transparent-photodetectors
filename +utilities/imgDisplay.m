function h = imgDisplay(varargin)
    import utilities.minWhiteSpace;
    labelOn = false;

    ax = axes;
    if nargin == 1
        img = varargin{1};
        h = imagesc(transpose(img), 'Parent', ax);
    elseif ischar( varargin{2} )
        img = varargin{1};
        h = imagesc(transpose(img), varargin{2:end}, 'Parent', ax);
    else
        x = varargin{1};
        y = varargin{2};
        img = varargin{3};
        h = imagesc(x, y, transpose(img), varargin{4:end}, 'Parent', ax);
    end

    if labelOn
        colormap('Gray'); colorbar;
        set(ax, 'YDir', 'normal');
    else
        colormap('Gray');
        set(ax, 'YDir', 'normal', 'XTick', [], 'YTick', [], 'XTickLabel', [], 'YTickLabel', []);
    end
    minWhiteSpace;
end