function drawframe_logo(f)
clf
L = membrane;
range = sin(linspace(pi/2,5*pi/2,48));
[x,y] = meshgrid(linspace(-1,1,size(L,1)),linspace(-1,1,size(L,2)));
sz = 2/31;
vert =  sz*(-1/2+[0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1]);
fac = [1 2 6 5;
     4 1 5 8;
     5 6 7 8
    ];
for i = 1:numel(L)
    patch('Vertices',vert+[x(i) y(i) range(f)*L(i)],'Faces',fac,'FaceVertexCData',range(f)*L(i),'FaceColor','flat', 'EdgeColor','none', 'FaceLighting','none')
end
view(-45,20)
colormap turbo
zlim([-1-sz/2, 1+sz/2]);
xlim([-1-sz/2, 1+sz/2]);
ylim([-1-sz/2, 1+sz/2]);
clim([-1,1]);
axis off
end