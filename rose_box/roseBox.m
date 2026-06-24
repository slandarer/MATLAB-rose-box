function roseBox(varargin)
% roseBox - Create a 3D heart-shaped rose gift box (创建 3D 心形玫瑰礼盒)
%   roseBox() creates a rose gift box with three default colormaps in the
%   current axes. The box contains roses arranged in a heart shape.
%   在当前坐标区使用三种默认配色创建心形玫瑰礼盒。
%
%   roseBox(CList) creates a rose gift box in the current axes using the
%   specified colormap cell array CList (length 3) for different rose positions.
%   在当前坐标区使用指定的配色元胞数组 CList (长度为3) 为不同位置的玫瑰花上色。
%
%   roseBox(ax) creates a rose gift box in the specified axes with default colormaps.
%   在指定坐标区使用默认配色创建心形玫瑰礼盒。
%
%   roseBox(ax, CList) creates a rose gift box in the specified axes using
%   the given colormap cell array.
%   在指定坐标区使用给定的配色元胞数组创建心形玫瑰礼盒。
%
% Input:
%   ax    - axes handle (optional) (坐标轴句柄，可选)
%   CList - 1×3 cell array, where each cell contains an N×3 RGB matrix with
%           values in [0, 1]. The three colormaps correspond to different
%           rose positions within the heart-shaped box. If not provided,
%           three default colormaps are used.
%           (1×3 元胞数组，每个元胞包含一个 N×3 RGB 矩阵，数值在 [0,1] 之间。
%            三种配色分别对应心形礼盒内不同位置的玫瑰花。若未提供，则使用三种默认配色。)


% Zhaoxu Liu / slandarer (2026). rose box 
% (https://github.com/slandarer/MATLAB-rose-box), GitHub. Retrieved May 19, 2026.
% 
% Zhaoxu Liu / slandarer (2026). rose box 
% (https://www.mathworks.com/matlabcentral/fileexchange/183906-rose-box), 
% MATLAB Central File Exchange. Retrieved May 19, 2026.
ax = gca; CList = {};
CList{1} = [.13 .10 .16; .20 .09 .20; .28 .08 .23; .42 .08 .30;
    .51 .07 .34; .66 .12 .35; .79 .22 .40; .88 .35 .47;
    .90 .45 .54; .89 .78 .79];
CList{2} = [.13 .10 .16; .20 .09 .20; .28 .08 .23; .42 .08 .30;
    .51 .07 .34; .66 .12 .35; .79 .22 .40; .88 .35 .47;
    .90 .45 .54; .89 .78 .79];
CList{3} = [88,17,26; 88,17,26; 139,0,0; 158,27,50; 205,92,92]./255;
if nargin >= 1 && isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = varargin{1};
    if nargin >= 2
        CList = varargin{2};
    end
elseif nargin >= 1
    CList = varargin{1};
    if nargin >= 2
        ax = varargin{2};
    end
end
if iscell(CList) && (length(CList) < 3)
    CList{3} = CList{1};
    CList{2} = CList{1};
elseif ~iscell(CList)
    CList = {CList};
    CList{3} = CList{1};
    CList{2} = CList{1};
end

% Generate heart-shaped box outline
tr = linspace(-pi/4, pi*.85, 100);
tl = linspace(pi*.15, 5*pi/4, 100);
X = [cos(tr) + 1, cos(tl) - 1, linspace(-1 - sqrt(2)/2, 1 + sqrt(2)/2, 100)];
Y = [sin(tr) + 1, sin(tl) + 1, linspace(1 - sqrt(2)/2, -sqrt(2), 50), linspace(-sqrt(2), 1 - sqrt(2)/2, 50)];
X = X.*1.15; Y = (Y - .764).*1.15 + .764;


hold(ax, 'on'); 
axis(ax, 'tight')
axis(ax, 'equal') 
axis(ax, 'off')
ax.Projection = 'perspective';
ax.Position = [- 1/9 + 1/18, -1/9, 11/9, 11/9];
ax.View = [-14.67, 47.27];

% Bottom face of the box
fill3(ax, X, Y, X.*0 + .3, [0, 0, 0])
% Create box wall surface with gradient color
X = repmat(X, [10, 1]); Y = repmat(Y, [10, 1]);
H = repmat(linspace(.3, 1.2, 10).', [1, 300]);
surf(ax, X, Y, H, 'FaceColor','interp', 'CData', H2C(H, [9,11,12; [59,36,62]./2]./255), ...
    'EdgeColor',[59,36,62]./2./255, 'EdgeAlpha',.5)

% Rose positions within the box
V = [0.00,  0.28; 0.47,  0.51; 0.71,  1.01; 0.00, -0.35; 0.42, -0.08;
     0.93,  0.42; 1.20,  1.04; 0.00,  0.85; 0.00, -1.00; 0.38,  1.28;
     0.82,  1.65; 1.42,  1.61; 1.66,  1.21; 1.56,  0.65; 1.28,  0.23; 
     0.87, -0.22; 0.48, -0.68];
C = [1; 1; 1; 2; 2; 2; 2; 3; 3; 3; 3; 3; 3; 3; 3; 3; 3];
Vl = [- V(:, 1), V(:, 2)]; Cl = C; 
Cl(Vl(:, 1) > -.01) = []; Vl(Vl(:, 1) > -.01, :) = []; 
C = [C; Cl]; V  = [V; Vl];

% Basic surface
[x, t] = meshgrid((0:24)./24, (0:.5:575)./575.*20.*pi + 4*pi);
p = (pi/2)*exp(-t./(8*pi));
u = 1 - (1 - mod(3.6*t, 2*pi)./pi).^4./2 + sin(15*t)/150;
y = 2*(x.^2 - x).^2.*sin(p);
r = u.*(x.*sin(p) + y.*cos(p));
h = u.*(x.*cos(p) - y.*sin(p)) + .35;
x = r.*cos(t); y = r.*sin(t);

% Draw roses at each position
Rz = @(yz) [cos(yz), - sin(yz), 0; sin(yz), cos(yz), 0; 0, 0, 1];
for k = 1:size(V, 1)
    [u, v, w] = matRotate(x.*.5, y.*.5, h - .05 + rand(1).*.05, Rz(rand(1)));
    surf(ax, u + V(k, 1), v + V(k, 2), w, 'EdgeAlpha',.05, 'EdgeColor','none', ...
        'FaceColor','interp', 'CData',H2C(h, CList{C(k)}));
end

    function C = H2C(H, cL)
        XX = rescale(H, 0, 1);
        C = interp1(rescale(1:size(cL, 1), 0, 1), cL, XX);
    end
    function [U, V, W] = matRotate(X, Y, Z, R)
        U = X; V = Y; W = Z;
        for i = 1:numel(X)
            vv = [X(i); Y(i); Z(i)];
            n = R*vv; U(i) = n(1); V(i) = n(2); W(i) = n(3);
        end
    end
end
