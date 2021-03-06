%% Generates a tesselated plane using Delaunay triangulation.
%
% ARGUMENTS:
%        n -- <description>
%
% OUTPUT: 
%        Vertices -- <description> 
%        Triangles --
%
% REQUIRES: 
%        DelaunayTri() -- Not yet available in Octave...
%
% USAGE:
%{
      <example-commands-to-make-this-function-run>
%}
%
% MODIFICATION HISTORY:
%     SAK(29-09-2010) -- Original.
%     SAK(Nov 2013)   -- Move to git, future modification history is
%                        there...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Vertices Triangles]=MakeTesselatedPlane(n)
  % Set any argument that weren't specified
  if nargin < 1,
    n = 10;
  end
  
  % 
  [X Y] = ind2sub(size(ones(n)), find(ones(n)));
  
  DT = DelaunayTri(X,Y);
  
  Triangles = DT.Triangulation;
  Vertices  = [X Y ones(size(X))];
  
  %TR = TriRep(DT.Triangulation, X, Y, ones(size(X)));

end %function MakeTesselatedPlane()
