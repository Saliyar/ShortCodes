function ErrorfoamStarExpt_pressure_compAll(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,PP_static,SWENSEsameMeshfile,cps,ccost)

                        ErrorfoamStarExpt_pressure_I(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost);
             
                       ErrorfoamStarExpt_pressure_II(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost);
           
                        ErrorfoamStarExpt_pressure_III(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost);
                        
end