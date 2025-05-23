addpath(genpath('../cobratoolbox'));
addpath(genpath('../Yeast_kapp'));
addpath(genpath('../Amino_acid/'));
initCobraToolbox;

load('GEM-yeast-split.mat'); % from https://github.com/SysBioChalmers/Amino_acid/blob/master/Models/GEM-yeast-split.mat

enzymedata = collectkcats(model_split.rxns(~ismember(model_split.rules,{''})),model_split,'saccharomyces cerevisiae');
enzymedata.kcat(enzymedata.kcat < quantile(enzymedata.kcat,0.1,1)) = quantile(enzymedata.kcat,0.1,1);
enzymedata = updateYeastEnzyme(enzymedata,model_split);

model = convertModel(model_split,enzymedata);

model = setYeastMedia(model);
model = changeRxnBounds(model,'r_1714',-1000,'l');
model = changeRxnBounds(model,'prot_cost_exchange',0.1,'u');

model = changeObjective(model,'r_2111');

sol = optimizeCbModel(model);
sol.f

save('model.mat',"model"); % the model saved in the path.