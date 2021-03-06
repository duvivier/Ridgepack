% ridgepack_JAMES_figure12 - Generates Figure 12 in JAMES Variational Ridging paper
% 
% This script generates Figure 12 from:
%
% Roberts, A.F., E.C. Hunke, S.M. Kamal, W.H. Lipscomb, C. Horvat, 
% W. Maslowski (2019), Variational Method for Sea Ice Ridging in 
% Earth System Models, J. Adv. Model Earth Sy.
%
% It generates a graphical example of the state space trajectory and 
% dilation field for a ridge with parent sheet thickness of 2m and no snow
% cover. This function is useful for testing the code in ridgepack_trajectory
% in the morphology library and that is why it was created.
%
% VERSION/CASES: Ridgepack 1.0.1/JAMES_2019_VarRidging
%
% CONTACT: Andrew Roberts, afroberts@lanl.gov 
%
% FILE HISTORY:
% Author: Andrew Roberts, Naval Postgraduate School, April 2018 
% Update: Andrew Roberts, Los Alamos National Laboratory, December 2018

% version check
[v d] = version;
if str2num(d(end-3:end))<2018
 warning('This script designed for MATLAB 2018a or more recent version')
end

% clear all variables and graphics
clear
close all

% Create figure
figure(1)

% font size for labels
fontlabel=15;

% switch to turn on/off the figure title 
titleflat=false;

% initial ice thickness (m)
hf=2.0;

% initial snow thickness (m)
hfs=0.0;

% retrieve constants
hc=ridgepack_astroconstants;
rho=hc.rhoi.const;  % density of ice (kg/m^3)
rhos=hc.rhos.const; % density of snow (kg/m^3)
rhow=hc.rhow.const; % density of seawater (kg/m^3)

% calculate trajectory for given thickness
[EPSILON,PHI,ALPHAHAT,VR,HK,HS,LK,LS,epmesh,phmesh,vr,epsplitmesh,...
   phsplitmesh,d1,d2]=ridgepack_trajectory(hf,hfs);

% set log color scale for potential energy density
%contourss=10.^[floor(log10(min(vr(:)))):0.25:ceil(log10(max(vr(:))))];
contourss=10.^[4:0.25:10];
cmap=colormap(parula(length(contourss)));
[zindex,truecol]=ridgepack_colorindex(vr,contourss,0);

% plot potential energy
surface(epmesh,phmesh,-0.1*ones(size(vr)),truecol,'EdgeColor','k')
shading flat
hold on

% plot the dilation field over the top as streamlines
hstr=streamslice(epsplitmesh,phsplitmesh,d1,d2);
set(hstr,'Color',[1 1 1])

% only plot zeta-hat trajector up to a min strain of -0.96
idx=find(EPSILON>=-0.96);
EPSILON=EPSILON(idx);
PHI=PHI(idx);
VR=VR(idx);

% plot ridging path
plot3(EPSILON,PHI,0.001*ones(size(VR)),'r','LineStyle','-','LineWidth',1.0)

% annote trajectory
text(EPSILON(end)+0.025,PHI(end),0.9,...
           ['$\hat{\zeta}$'],...
            'Color','r',...
            'Fontsize',fontlabel,...
            'FontWeight','bold',...
            'Rotation',10,...
            'Margin',0.5,...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','center',...
            'Interpreter','Latex')

% arrow head of mean path
text(EPSILON(end)+0.008,PHI(end),0.9,...
                 ['$\bigtriangleup$'],...
                 'Color','r',...
                 'Fontsize',9,...
                 'FontWeight','bold',...
                 'Margin',0.0001,...
                 'Rotation',90,...
                 'VerticalAlignment','bottom',...
                 'HorizontalAlignment','center',...
                 'Interpreter','Latex')

% set the dynamic limits
xlim([-0.99 0])
ylim([0 0.99])
zlim([-1 1])

% plot the colorbar
ridgepack_colorbar(contourss,['J m^{-2}'],0.1,'vertical');

% fiddle to get the grid to plot
grid
grid off
grid on

% set font size
set(gca,'FontSize',fontlabel-2)

% set log scale for z-axis 
set(gca,'Box','on','TickLabelInterpreter','Latex','Layer','top')

% set tick marks
set(gca,'Xtick',[-0.9:0.1:0])
set(gca,'Ytick',[0:0.1:0.9])

% axis labels
xlabel('Strain, $\epsilon_{R_I}$','Interpreter','Latex','fontsize',fontlabel)
ylabel('Porosity, $\phi_R$','Interpreter','Latex','fontsize',fontlabel)

if titleflat

 % title
 title(['Dilation field and state space trajectory for $h_f=$',num2str(hf),...
        'm, $h_{f_s}=$',num2str(hfs),'m'])
 
 % fix axes
 axis square

else

 % changes the position
 set(gca,'Position',[0.15 0.09 0.7 0.9])

end

% determine directory for read/write
dir=fileparts(which(mfilename));
outdir=[dir(1:strfind(dir,'scripts')-1),'output'];
[status,msg]=mkdir(outdir);
cd(outdir);

% determine filename
x=strfind(mfilename,'_');
thisfilename=mfilename;
graphicsout=thisfilename(x(end)+1:end);

% output
disp(['Writing graphics output ',graphicsout,' to:',char(13),' ',pwd])

% print figure
ridgepack_fprint('epsc',graphicsout,1,2)
ridgepack_fprint('png',graphicsout,1,2)


