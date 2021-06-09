function wv_free = eval_free_waves(wv_2D, n_evan, TF_type, i_plot, superp)
% wv_free = eval_free_waves(wv_2D, n_evan, TF_type)
% @WAVE_2D\EVAL_FREE_WAVES evaluates the free wave characteristics for the wave object
% Inputs:
%   wv_2D               is a wave object,
%   n_evan              is the number of evanescent modes for the sums
%   TF_type             is the law of control of the wavemaker
% Output:
%   wv_free  is a wave object containing the free waves details.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if nargin < 4
    i_plot = 0;
end
% Going to nondimensional form
depth = get(wv_2D, 'depth');
wv_2D = convert2nondim(wv_2D);
if strcmp(get(wv_2D,'type'),'biflap') && nargin >= 3 % biflap wavemaker
    wv_2D = set(wv_2D, 'TF', TF_type);
end
%
if length(wv_2D) == 1
    omega  = get(wv_2D,'pulsation');
    ampli  = get(wv_2D,'amplitude') .* exp(1i * get(wv_2D,'phase'));
    %
    alpha_n    = calc_alpha_n(get(wv_2D,'frequency'), n_evan);
    D_mn       = calc_D_mn(alpha_n, omega);
    % Transfer functions
    [TF, TF_n]   = calc_TF_TF_n(wv_2D, alpha_n);
    % Amplitude of the free wave
    a_free_n = calc_a_free_n(D_mn, TF_n, omega);
    a_free_n = ampli.^2 .* a_free_n;
    % Going back to dimensional form
    wv_2D    = convert2dim(wv_2D, depth);
    a_free_n = a_free_n * depth;
    % Creating the wave output
    wv_free = wave(get(wv_2D,'T_repeat'),get(wv_2D,'f_samp'),harmonic(get(wv_2D,'harmo')*2,abs(a_free_n),angle(a_free_n),0),get(wv_2D,'wavemaker'));
    wv_free = set(wv_free, 'TF', 1);
else
    n_harmo = length(wv_2D);
    harmo   = get(wv_2D, 'harmo');
    ampli   = get(wv_2D, 'ampli');
    phase   = get(wv_2D, 'phase');
    %
    d        = get(wv_2D,'hinge_bottom');
    D        = get(wv_2D,'middle_flap');
    T_repeat = get(wv_2D,'T_repeat');
    f_samp   = get(wv_2D,'f_samp');
    wmk      = get(wv_2D,'wavemaker');
    %
    % Finding the required sum and difference terms
    [present_p, present_m, eval_inter, required] = find_useful_pm(harmo, ampli, n_harmo);
    tic
    h_wait = init_wait_time_bar('Evaluating TF_n and stuff');
    % temporary storage
    omega_4 = zeros(1,n_harmo);
    for n1=n_harmo:-1:1 % last element in harmo gives the longest evaluation time so it's done first
        if required(n1) == 1
            wv_tmp      = harmonic(harmo(n1),ampli(n1),phase(n1)); % wave object
            wv_tmp      = convert2nondim(wv_tmp, 1);           % false conversion (for compatibility reasons)
            wv_2D_tmp   = wave(T_repeat,f_samp,wv_tmp,wmk); % wave object
            if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
                if nargin < 3 
                    TF_type = get(wv_2D, 'TF_type');
                end
                wv_2D_tmp = set(wv_2D_tmp, 'TF', TF_type);
            end
            omega(n1)   = get(wv_2D_tmp,'pulsation');
            omega_4(n1) = omega(n1)^4;
%             wave_info   = info('pulsation', omega(n1));
            n           = 1:n_evan+1;
            alpha_n(n,n1) = (calc_alpha_n(get(wv_2D_tmp,'frequency'), n_evan)).';
            [I, J_n]      = calc_I_J_n(alpha_n(n,n1), d, D);
            if strcmp(get(wv_2D_tmp,'type'),'biflap') && TF_type > 3
                [p_n, q_n] = calc_pn_qn(alpha_n(n,n1), I, J_n);
                D_mn       = calc_D_mn(alpha_n(n,n1), omega(n1));
                TF         = TF_wmk(wv_2D_tmp, I, p_n, q_n, D_mn);
            else
                TF = TF_wmk(wv_2D_tmp);
            end
            TF_n(n,1:2,n1) = calc_TF_n(alpha_n(n,n1), TF, J_n);
            TF_n_12(n,n1)  = TF_n(n,1,n1)+TF_n(n,2,n1);
            wait_time_bar(h_wait, 1-n1/n_harmo+1.e-4, 'Evaluating TF_n and stuff')
        end
    end
    % Keeping the same waitbar but reinitialising time
    tic
    % Evaluating the corresponding frequencies and wavenumbers
    [omega_p, omega_m, beta_p, beta_m] = calc_pm_omega_wnb(eval_inter, present_p, present_m, omega, harmo, n_harmo, h_wait);
    disp('Frequencies and wavenumbers evaluated')
    % Keeping the same waitbar but reinitialising time and title
    tic
    wait_time_bar(h_wait, 1.e-4, ['n1 = ',num2str(1) ' over ' num2str(n_harmo)])
    % Let's go to the big loop
    % complex amplitudes
    ampli_sum    = zeros(1,2*harmo(n_harmo));
    ampli_diff   = zeros(1,2*harmo(n_harmo));
    ampli_Stokes = zeros(1,2*harmo(n_harmo));
    ampli_return = zeros(1,1);
    a_plus  = zeros(n_harmo, n_harmo);
    a_minus = zeros(n_harmo, n_harmo);
    harmo_sum    = zeros(1,2*harmo(n_harmo));
    harmo_diff   = zeros(1,2*harmo(n_harmo));
    harmo_Stokes = zeros(1,2*harmo(n_harmo));
    col_one = ones(n_evan+1,1);
    %     N_eval = sum(sum(eval_inter));
    for n1=n_harmo:-1:1
        % Useful
        if any(eval_inter(n1,:)) == 1
            alpha_1_mat   = col_one * alpha_n(:,n1).';
            alpha_1_mat_2 = alpha_1_mat .* alpha_1_mat;
            a_1           = ampli(n1) .* exp(i * phase(n1));
        end
        for n2=1:n1-1
            if eval_inter(n1,n2) == 1
                % Needed terms
                % Pulsations
                omega_1p2 = omega_p(harmo(n1)+harmo(n2));
                omega_1m2 = sign(harmo(n1)-harmo(n2)) * omega_m(abs(harmo(n1)-harmo(n2)));
                % Wavenumbers
                beta_0_plus   = beta_p(harmo(n1)+harmo(n2));
                beta_0_minus  = beta_m(abs(harmo(n1)-harmo(n2)));
                % Useful
                omega_12_2   = (omega(n1) * omega(n2))^2;
                % alpha_m_1 and alpha_n_2 into matrices
                alpha_2_mat = col_one * alpha_n(:,n2).';
                %
                % Sum term
                % alpha_m_1 +, - or * alpha_n_2
                alpha_1p2 = alpha_1_mat + alpha_2_mat.';
                alpha_1m2 = alpha_1_mat - alpha_2_mat.';
                alpha_1t2 = calc_alpha_1t2(alpha_n(:,n1),alpha_n(:,n2));
                %
                L_mn_12_plus = calc_L_mn_12_pm(+1, omega(n1), omega(n2), omega_4(n1), omega_4(n2), ...
                    omega_12_2, alpha_1t2, alpha_2_mat, alpha_1_mat_2);
                %
                oneo_plus = calc_oneo_beta_alpha2(beta_0_plus, alpha_1p2);
                %
                G_M_plus = calc_G_M_pm(+1, omega(n1), omega(n2), oneo_plus, ...
                    omega_1p2, omega_12_2, alpha_1t2, alpha_1p2, alpha_1_mat, alpha_2_mat);
                %
                K_M_plus = calc_K_M(L_mn_12_plus, oneo_plus, omega(n1), omega(n2));
                %
                oneo_plus = calc_oneo_beta_alpha2(beta_0_plus, alpha_1m2);
                %
                H_M_plus = calc_H_M_pm(+1, omega(n1), omega(n2), oneo_plus, ...
                    omega_1m2, omega_12_2, alpha_1t2, alpha_1m2, alpha_1_mat, alpha_2_mat);
                %
                a_2    = ampli(n2) .* exp(i * phase(n2));
                TF_1t2 = TF_n_12(:,n2) * TF_n_12(:,n1).';
                %
                M = ((exp(2*beta_0_plus) - exp(-2*beta_0_plus))/2 + 2*beta_0_plus) / ( beta_0_plus * (exp(beta_0_plus) + ...
                    exp(-beta_0_plus))^2);
                %
                % Complete term
                amplitude = omega_1p2 / (beta_0_plus * M) * sum(sum((alpha_1p2 .* (G_M_plus + K_M_plus) + alpha_1m2 .* H_M_plus) .* TF_1t2 ));
                % Bound related term only
                %                 amplitude = omega_1p2 / (beta_0_plus * M) * sum(sum(alpha_1p2 .* K_M_plus .* TF_1t2 ));
                % Wavemaker related only
                %                 amplitude = omega_1p2 / (beta_0_plus * M) * sum(sum((alpha_1p2 .* G_M_plus + alpha_1m2 .* H_M_plus) .* TF_1t2 ));
                % Maps
                wv_tmp      = harmonic(harmo(n1)+harmo(n2), 1, 0); % wave object
                wv_tmp      = convert2nondim(wv_tmp, 1);           % false conversion (for compatibility reasons)
                wv_2D_tmp   = wave(T_repeat,f_samp,wv_tmp,wmk); % wave object
                if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
                    if nargin < 3 
                        TF_type = get(wv_2D, 'TF_type');
                    end
                    wv_2D_tmp = set(wv_2D_tmp, 'TF', TF_type);
                end
                %                 wv_2D_tmp   = set(wv_2D_tmp, 'TF', TF_type); % transfer function
                if strcmp(get(wv_2D_tmp,'type'),'biflap') && TF_type > 3
%                     wave_info                = info('pulsation', omega_1p2);
                    alpha_n_plus(1:n_evan+1) = (calc_alpha_n(omega_1p2/2/pi, n_evan)).';
                    [I, J_n]                 = calc_I_J_n(alpha_n_plus(1:n_evan+1), d, D);
                    [p_n, q_n]               = calc_pn_qn(alpha_n_plus(1:n_evan+1), I, J_n);
                    D_mn                     = calc_D_mn(alpha_n_plus(1:n_evan+1), omega_1p2);
                    %
                    TF = TF_wmk(wv_2D_tmp, I, p_n, q_n, D_mn);
                else % then TF(2)=0
                    TF = TF_wmk(wv_2D_tmp);
                end
                if strcmp(get(wv_2D_tmp,'type'),'piston')
                    TF = TF(2);
                elseif strcmp(get(wv_2D_tmp,'type'),'monoflap')
                    TF = TF(1);
                elseif strcmp(get(wv_2D_tmp,'type'),'biflap')
                    if get(wv_2D_tmp,'TF') == 2
                        TF = TF(2);
                    elseif get(wv_2D_tmp,'TF') == 1
                        TF = TF(1);
                    elseif get(wv_2D_tmp,'TF') == 3
                        TF = TF(1);
                    end
                else
                    TF = 0;
                end
                a_plus(n1,n2) = - i * amplitude * TF;
                %                 a_plus(n1,n2) = - amplitude;
                a_plus(n2,n1) = a_plus(n1,n2);
                %
                amplitude = amplitude .* a_1 .* a_2;
                if abs(amplitude) > 1.e-10
                    harmo_sum(harmo(n1)+harmo(n2)) = harmo(n1)+harmo(n2);
                    ampli_sum(harmo(n1)+harmo(n2)) = ampli_sum(harmo(n1)+harmo(n2)) + amplitude;
                end
                %
                % Difference term
                % alpha_m_1 +, - or * conj(alpha_n_2)
                alpha_2_mat = conj(alpha_2_mat);
                alpha_1p2 = alpha_1_mat + alpha_2_mat.'; % second term is the complex conjugate
                alpha_1m2 = alpha_1_mat - alpha_2_mat.'; % second term is the complex conjugate
                alpha_1t2 = calc_alpha_1t2(alpha_n(:,n1), conj(alpha_n(:,n2))); % second term is the complex conjugate
                %
                L_mn_12_minus = calc_L_mn_12_pm(-1, omega(n1), omega(n2), omega_4(n1), omega_4(n2), ...
                    omega_12_2, alpha_1t2, alpha_2_mat, alpha_1_mat_2);
                %
                oneo_minus = calc_oneo_beta_alpha2(beta_0_minus, alpha_1p2);
                %
                G_M_minus = calc_G_M_pm(-1, omega(n1), omega(n2), oneo_minus, ...
                    omega_1p2, omega_12_2, alpha_1t2, alpha_1p2, alpha_1_mat, alpha_2_mat);
                %
                oneo_minus = calc_oneo_beta_alpha2(beta_0_minus, alpha_1m2);
                %
                H_M_minus = calc_H_M_pm(-1, omega(n1), omega(n2), oneo_minus, ...
                    omega_1m2, omega_12_2, alpha_1t2, alpha_1m2, alpha_1_mat, alpha_2_mat);
                %
                K_M_minus = calc_K_M(L_mn_12_minus, oneo_minus, omega(n1), omega(n2));
                %
                TF_1t2 = conj(TF_n_12(:,n2)) * TF_n_12(:,n1).'; % second term is the complex conjugate
                %
                M = ((exp(2*beta_0_minus) - exp(-2*beta_0_minus))/2 + 2*beta_0_minus) / ( beta_0_minus * (exp(beta_0_minus) + exp(-beta_0_minus))^2);
                %
                % Complete term
                amplitude = abs(omega_1m2) / (beta_0_minus * M) * (sum(sum(alpha_1p2 .* G_M_minus  .* TF_1t2))...
                    + sum(sum(alpha_1m2 .* (H_M_minus +K_M_minus) .* TF_1t2)));
                % Bound related term only
                %                 amplitude = omega_1m2 / (beta_0_minus * M) * sum(sum(alpha_1m2 .* K_M_minus .* TF_1t2 ));
                % Wavemaker related only
                %                 amplitude = omega_1m2 / (beta_0_minus * M) * sum(sum((alpha_1p2 .* G_M_minus + alpha_1m2 .* H_M_minus) .* TF_1t2 ));
                % Maps
                wv_tmp      = harmonic(abs(harmo(n1)-harmo(n2)), 1, 0); % wave object
                wv_tmp      = convert2nondim(wv_tmp, 1);           % false conversion (for compatibility reasons)
                wv_2D_tmp   = wave(T_repeat,f_samp,wv_tmp,wmk); % wave object
                if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
                    if nargin < 3 
                        TF_type = get(wv_2D, 'TF_type');
                    end
                    wv_2D_tmp = set(wv_2D_tmp, 'TF', TF_type);
                end
                %                 wv_2D_tmp   = set(wv_2D_tmp, 'TF', TF_type); % transfer function
                if strcmp(get(wv_2D_tmp,'type'),'biflap') && TF_type > 3
%                     wave_info                 = info('pulsation', omega_1m2);
                    alpha_n_minus(1:n_evan+1) = (calc_alpha_n(omega_1m2/2/pi, n_evan)).';
                    [I, J_n]                  = calc_I_J_n(alpha_n_minus(1:n_evan+1), d, D);
                    [p_n, q_n]                = calc_pn_qn(alpha_n_minus(1:n_evan+1), I, J_n);
                    D_mn                      = calc_D_mn(alpha_n_minus(1:n_evan+1), omega_1p2);
                    TF                        = TF_wmk(wv_2D_tmp, I, p_n, q_n, D_mn);
                else % then TF(2)=0
                    TF = TF_wmk(wv_2D_tmp);
                end
                if strcmp(get(wv_2D_tmp,'type'),'piston')
                    TF = TF(2);
                elseif strcmp(get(wv_2D_tmp,'type'),'monoflap')
                    TF = TF(1);
                elseif strcmp(get(wv_2D_tmp,'type'),'biflap')
                    if get(wv_2D_tmp,'TF') == 2
                        TF = TF(2);
                    elseif get(wv_2D_tmp,'TF') == 1
                        TF = TF(1);
                    elseif get(wv_2D_tmp,'TF') == 3
                        TF = TF(1);
                    end
                else
                    TF = 0;
                end
                %                 if strcmp(TF_type,'piston') || TF_type == 2
                %                     TF = TF(2);
                %                 elseif TF_type == 1
                %                     TF = TF(1);
                %                 else
                %                     warning('Bad TF_type for maps')
                %                     TF = 0;
                %                 end
                a_minus(n1,n2) = - i * amplitude * TF;
                %                 a_minus(n1,n2) = - amplitude;
                a_minus(n2,n1) = a_minus(n1,n2);
                %
                amplitude = amplitude .* a_1 .* conj(a_2);
                if abs(amplitude) > 1.e-10
                    harmo_diff(abs(harmo(n1)-harmo(n2))) = abs(harmo(n1)-harmo(n2));
                    ampli_diff(abs(harmo(n1)-harmo(n2))) = ampli_diff(abs(harmo(n1)-harmo(n2))) + amplitude;
                end
            end
        end
        if eval_inter(n1,n1) == 1
            %
            % Stokes term (n1=n2)
            amplitude = calc_Stokes(1, omega(n1), alpha_n(:,n1), TF_n(:,:,n1));
            wv_tmp      = harmonic(2*harmo(n1), 1, 0); % wave object
            wv_tmp      = convert2nondim(wv_tmp, 1);           % false conversion (for compatibility reasons)
            wv_2D_tmp   = wave(T_repeat,f_samp,wv_tmp,wmk); % wave object
            if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
                if nargin < 3 
                    TF_type = get(wv_2D, 'TF_type');
                end
                wv_2D_tmp = set(wv_2D_tmp, 'TF', TF_type);
            end
            %             wv_2D_tmp   = set(wv_2D_tmp, 'TF', TF_type); % transfer function
            if strcmp(get(wv_2D_tmp,'type'),'biflap') && TF_type > 3
%                 wave_info                = info('pulsation', omega_1m2);
                alpha_n_S(1:n_evan+1) = (calc_alpha_n(omega_1m2/2/pi, n_evan)).';
                [I, J_n]            = calc_I_J_n(alpha_n_S(1:n_evan+1), d, D);
                [p_n, q_n]          = calc_pn_qn(alpha_n_S(1:n_evan+1), I, J_n);
                D_mn                    = calc_D_mn(alpha_n_S(1:n_evan+1), omega_1p2);
                TF = TF_wmk(wv_2D_tmp, I, p_n, q_n, D_mn);
            else % then TF(2)=0
                TF = TF_wmk(wv_2D_tmp);
            end
            if strcmp(get(wv_2D_tmp,'type'),'piston')
                TF = TF(2);
            elseif strcmp(get(wv_2D_tmp,'type'),'monoflap')
                TF = TF(1);
            elseif strcmp(get(wv_2D_tmp,'type'),'biflap')
                if get(wv_2D_tmp,'TF') == 2
                    TF = TF(2);
                elseif get(wv_2D_tmp,'TF') == 1
                    TF = TF(1);
                elseif get(wv_2D_tmp,'TF') == 3
                    TF = TF(1);
                end
            else
                TF = 0;
            end
            %             if strcmp(TF_type,'piston') | TF_type == 2
            %                 TF = TF(2);
            %             elseif TF_type == 1
            %                 TF = TF(1);
            %             else
            %                 TF = 0;
            %             end
            a_plus(n1,n1) = - 2 * i * amplitude * TF;
            %             a_plus(n1,n1) = - amplitude;
            amplitude = a_1 * a_1 * amplitude;
            if abs(amplitude) > 1.e-15
                harmo_Stokes(2*harmo(n1)) = 2*harmo(n1);
                ampli_Stokes(2*harmo(n1)) = amplitude;
            end
            %
            % Return current term
            amplitude = - alpha_n(1,n1) * a_1 * conj(a_1) / (2 * omega(n1));
            %             a_minus(n1,n1) = amplitude;
            ampli_return = ampli_return + amplitude;
        end
        wait_time_bar(h_wait, (1-(n1-1)/n_harmo * (n1-1+1)/(n_harmo+1)), ['n1 = ',num2str(n1) ' over ' num2str(n_harmo)])
    end

    %% i_plot == 2
    if i_plot == 2
        figure(11),clf
        harmo      = get(wv_2D, 'harmo');
        ampli      = get(wv_2D, 'ampli') .* exp(i * get(wv_2D, 'phase'));
        freq_plot = harmo / (get(wv_2D,'T_repeat') * sqrt(depth/9.81));
        %         subplot(2,1,1)
        semilogy(freq_plot, abs(ampli),'ko-');
        %         subplot(2,1,2)
        %         plot(freq_plot, angle(ampli),'ko-');
        freq_plot = ((1:2*harmo(n_harmo))-1) / (get(wv_2D,'T_repeat') * sqrt(depth/9.81));
        %         subplot(2,1,1)
        hold on
        semilogy(freq_plot, abs(ampli_sum),'o-', freq_plot, abs(ampli_diff),'o-', freq_plot, abs(ampli_Stokes),'o-', 0, abs(ampli_return), 'o');
        hold off
        xlim([-0.0001 1.05*max(freq_plot)])
        %         subplot(2,1,2)
        %         hold on
        %         plot(freq_plot, angle(ampli_sum),'o-', freq_plot, angle(ampli_diff),'o-', freq_plot, angle(ampli_Stokes),'o-', 0, angle(ampli_return), 'o');
        %         hold off
        %         xlim([-0.0001 1.05*max(freq_plot)])
        %
        figure(11)
    end
    %% i_plot == 1
    if i_plot == 1
        figure(12)
        set(gcf, 'PaperType', 'a4');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPositionMode','manual');
        set(gcf, 'PaperPosition', [3 3 16 6.5]);
        % Difference modes (sub-harmonics)
        set(gcf,'position',[8   110   843   250])
        subplot(1,2,1)
        v_long  = [-128 -64 -32 -16 -8 -4 -2 -1 -0.5 0 0.5 1 2 4 8 16 32 64 128];
        v_short = [-16 -8 -4 -2 -1 -0.5 0 0.5 1 2 4 8 16];
        if nargin > 4
            hold on
            [C,handle] = contour(omega, omega, real(a_minus), v_short);
            hold off
        else
            [C,handle] = contour(omega, omega, real(a_minus), v_short);
        end
        set(gca,'xtick',[0 1 2 3 4])
        set(gca,'ytick',[0 1 2 3 4])
        if strcmp(version,'6.5.0.180913a (R13)')
            clabel(C,handle)
        else
            set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
        end
        caxis([-20 20])
        hold on
        contour(omega, omega, real(a_minus), v_long);
        % fm = fn / 2 lines
        % line([0 4],[0, 4/2])
        % line([0 4/2],[0, 4])
        % fm = fn / 4 lines
        line([0 4],[0, 4/4])
        line([0 4/4],[0, 4])
        hold off
        xlabel('n')
        ylabel('m')
        xlim([0 4.0001])
        ylim([0 4.0001])
        subplot(1,2,2)
        if nargin > 4
            hold on
            [C,handle] = contour(omega, omega, imag(a_minus), v_short);
            hold off
        else
            [C,handle] = contour(omega, omega, imag(a_minus), v_short);
        end
        set(gca,'xtick',[0 1 2 3 4])
        set(gca,'ytick',[0 1 2 3 4])
        if strcmp(version,'6.5.0.180913a (R13)')
            clabel(C,handle)
        else
            set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
        end
        caxis([-20 20])
        hold on
        contour(omega, omega, imag(a_minus), v_long);
        % fm = fn / 2 lines
        % line([0 4],[0, 4/2])
        % line([0 4/2],[0, 4])
        % fm = fn / 4 lines
        line([0 4],[0, 4/4])
        line([0 4/4],[0, 4])
        hold off
        xlabel('n')
        ylabel('m')
        xlim([0 4.0001])
        ylim([0 4.0001])
        % Sum modes (super-harmonics)
        figure(13)
        set(gcf, 'PaperType', 'a4');
        set(gcf, 'PaperUnits', 'centimeters');
        set(gcf, 'PaperPositionMode','manual');
        set(gcf, 'PaperPosition', [3 3 16 6.5]);
        set(gcf,'position',[8 120 843 250])
        subplot(1,2,1)
        if nargin > 4
            hold on
            [C,handle] = contour(omega, omega, real(a_plus), v_short);
            hold off
        else
            [C,handle] = contour(omega, omega, real(a_plus), v_short);
        end
        if strcmp(version,'6.5.0.180913a (R13)')
            clabel(C,handle)
        else
            set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
        end
        caxis([-20 20])
        hold on
        contour(omega, omega, real(a_plus), v_long);
        line([0 4],[0, 4/2])
        line([0 4/2],[0, 4])
        line([0 4],[0, 4/4])
        line([0 4/4],[0, 4])
        hold off
        xlabel('n')
        ylabel('m')
        xlim([0 4.0001])
        ylim([0 4.0001])
        subplot(1,2,2)
        if nargin > 4
            hold on
            [C,handle] = contour(omega, omega, imag(a_plus), v_short);
            hold off
        else
            [C,handle] = contour(omega, omega, imag(a_plus), v_short);
        end
        if strcmp(version,'6.5.0.180913a (R13)')
            clabel(C,handle)
        else
            set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
        end
        caxis([-20 20])
        hold on
        contour(omega, omega, imag(a_plus), v_long);
        line([0 4],[0, 4/2])
        line([0 4/2],[0, 4])
        line([0 4],[0, 4/4])
        line([0 4/4],[0, 4])
        hold off
        xlabel('n')
        ylabel('m')
        xlim([0 4.0001])
        ylim([0 4.0001])
        figure(12)
        var = char('m', 'n', 'r', 'i');
        tec = tecplot('D:\Félicien\Matlab\bichromatic\Schaffer_map\test_mat_plus.dat', 'Matlab''s version of F^pm', var);
        fid = write_header(tec);
        zon = zone('Matlab', 4, [length(harmo), length(harmo)], 'POINT');
        for n=1:length(harmo)
            for m=1:n_harmo
                data(n,m,1) = omega(n);
                data(n,m,2) = omega(m);
                data(n,m,3) = real(a_plus(n,m));
                data(n,m,4) = imag(a_plus(n,m));
            end
        end
        zon = set(zon, 'data', data);
        write_zone(zon,fid);
        fclose(fid);
        %
        tec = tecplot('D:\Félicien\Matlab\bichromatic\Schaffer_map\test_mat_minus.dat', 'Matlab''s version of F^pm', var);
        fid = write_header(tec);
        zon = zone('Matlab', 4, [length(harmo), length(harmo)], 'POINT');
        for n=1:length(harmo)
            for m=1:n_harmo
                data(n,m,3) = real(a_minus(n,m));
                data(n,m,4) = imag(a_minus(n,m));
            end
        end
        zon = set(zon, 'data', data);
        write_zone(zon,fid);
        fclose(fid);
    end
    %%
    figure(h_wait)
    % Creating the wave output
    %     wv = harmonic(); % null wave object
    tic
    n_sum    = sum(abs(ampli_sum)    > 0);
    n_diff   = sum(abs(ampli_diff)   > 0);
    n_Stokes = sum(abs(ampli_Stokes) > 0);
    eps      = 1.0e-8;
    n_sum_eff    = sum(abs(ampli_sum)    > eps);
    n_diff_eff   = sum(abs(ampli_diff)   > eps);
    n_Stokes_eff = sum(abs(ampli_Stokes) > eps);
    toc
    %     [n_sum_eff, n_diff_eff, n_Stokes_eff] = calc_n_eff(h_wait, eval_inter, harmo, n_harmo, ampli_sum, ampli_diff, ampli_Stokes);
    harmo_free = zeros(1,n_sum_eff + n_diff_eff + n_Stokes_eff);
    ampli_free = zeros(1,n_sum_eff + n_diff_eff + n_Stokes_eff);
    phase_free = zeros(1,n_sum_eff + n_diff_eff + n_Stokes_eff);
    disp(['Number of sum useful terms is         ' int2str(n_sum_eff)    ' instead of ' int2str(n_sum) ...
        '. Gain: ' int2str(floor(100*(1-n_sum_eff / n_sum)))])
    disp(['Number of difference useful terms is  ' int2str(n_diff_eff)   ' instead of ' int2str(n_diff) ...
        '. Gain: ' int2str(floor(100*(1-n_diff_eff / n_diff)))])
    disp(['Number of Stokes useful components is ' int2str(n_Stokes_eff) ' instead of ' int2str(n_Stokes) ...
        '. Gain: ' int2str(floor(100*(1-n_Stokes_eff / n_Stokes)))])
    n_store = 1;
    for n=1:2*harmo(n_harmo)
        if abs(ampli_sum(n)) > eps
            harmo_free(n_store) = harmo_sum(n);
            ampli_free(n_store) = abs(ampli_sum(n));
            phase_free(n_store) = angle(ampli_sum(n));
            n_store = n_store + 1;
        end
        if abs(ampli_diff(n)) > eps
            harmo_free(n_store) = harmo_diff(n);
            ampli_free(n_store) = abs(ampli_diff(n));
            phase_free(n_store) = angle(ampli_diff(n));
            n_store = n_store + 1;
        end
        if abs(ampli_Stokes(n)) > eps
            harmo_free(n_store)   = harmo_Stokes(n);
            ampli_free(n_store)   = abs(ampli_Stokes(n));
            phase_free(n_store)   = angle(ampli_Stokes(n));
            n_store = n_store + 1;
        end
        wait_time_bar(h_wait, n/(2*harmo(n_harmo)), ['Building output wave, n1 = ',num2str(n) ' over ' num2str(2*harmo(n_harmo))])
        %         wait_time_bar(h_wait, n1/n_harmo * (n1+1)/(n_harmo+1), ['n1 = ',num2str(n1) ' over ' num2str(n_harmo)])
    end
    close(h_wait)

    %     [harmo_free permut] = sort(harmo_free);
    %     ampli_free = ampli_free(permut);
    %     phase_free = phase_free(permut);
    %     back to dimensional form
    ampli_free = ampli_free * depth;
    wv = harmonic(harmo_free, ampli_free, phase_free);
    %     wv = clean(wv);
    %     back to dimensional form
    wv_2D   = convert2dim(wv_2D,depth);
    wv_free = wave(get(wv_2D,'T_repeat'),get(wv_2D,'f_samp'),wv,get(wv_2D,'wavemaker'));
    if nargin >= 3 % biflap wavemaker
        wv_free = set(wv_free, 'TF', TF_type);
    end
end
%
function oneo_beta_alpha2 = calc_oneo_beta_alpha2(beta_0, alpha_12)
oneo_beta_alpha2          = 1 ./ (beta_0^2 - alpha_12.^2);
%
function G_M_pm = calc_G_M_pm(pm, omega_1, omega_2, oneo_G,...
    omega_1p2, omega_12_2, alpha_1t2, alpha_1p2, alpha_1_mat, alpha_2_mat)
G_M_pm = pm * omega_1p2 ./ (4.*omega_12_2) .* ...
    ((omega_1 + pm * omega_2)^2 .* (omega_12_2 + alpha_1t2) - ...
    alpha_1p2 .* (alpha_1_mat .* omega_2^2 + alpha_2_mat.' .* omega_1^2) ) .* oneo_G;
%
function H_M_pm = calc_H_M_pm(pm, omega_1, omega_2, oneo, ...
    omega_1m2, omega_12_2, alpha_1t2, alpha_1m2, alpha_1_mat, alpha_2_mat)
H_M_pm = - pm * omega_1m2 ./ (4.*omega_12_2) .* ...
    ((omega_1 + pm * omega_2)^2 .* (omega_12_2 - alpha_1t2) - alpha_1m2 .* (alpha_1_mat .* omega_2^2 - alpha_2_mat.' .* omega_1^2 )) .* ...
    oneo;
%
function K_M = calc_K_M(L_mn_12, oneo, omega_1, omega_2)
K_M = L_mn_12 .* oneo ./ (2*omega_1 * omega_2);
%
function L_mn_12_pm = calc_L_mn_12_pm(pm, omega_1, omega_2, omega_1_4, omega_2_4, ...
    omega_12_2, alpha_1t2, alpha_2_mat, alpha_1_mat_2)
L_mn_12_pm = pm * 2 .* (omega_1 + pm * omega_2) .* (omega_12_2 - pm * alpha_1t2) + pm * omega_1 .* (omega_2_4 - (alpha_2_mat.^2).') + ...
    omega_2 .* (omega_1_4 - alpha_1_mat_2);
%
function alpha_1t2 = calc_alpha_1t2(alpha_1,alpha_2)
alpha_1t2          = alpha_2 * alpha_1.';
%
function amplitude = calc_Stokes(ampli_C, omega, alpha, TF_n)
%
D_mn      = calc_D_mn(alpha(:).', omega);
% Amplitude of the free wave
amplitude = calc_a_free_n(D_mn, TF_n(:,:), omega);
amplitude = ampli_C .* ampli_C .* amplitude;
%
function [present_p, present_m, eval_inter, required] = find_useful_pm(harmo, ampli, n_harmo)
%
% Evaluates the required interactions
eval_inter = zeros(n_harmo,n_harmo);
required   = zeros(1,n_harmo);
A_max      = max(abs(ampli));
N_eval     = 0;
present_p = zeros(1,2*harmo(n_harmo));
present_m = zeros(1,harmo(n_harmo));
for n1=1:n_harmo
    % Sum and difference terms
    for n2=1:n1-1
        if ampli(n1)*ampli(n2) > 1e-4*A_max*A_max
            % deals with both sum and difference terms
            eval_inter(n1,n2) = 1;
            N_eval            = N_eval + 1;
            present_p(harmo(n1)+harmo(n2))      = 1;
            present_m(abs(harmo(n1)-harmo(n2))) = 1;
            required(n2) = 1;
        end
    end
    % Stokes terms
    if ampli(n1)*ampli(n1) > 1e-4*A_max*A_max
        eval_inter(n1,n1) = 1;
        N_eval            = N_eval + 1;
    end
    if any(eval_inter(n1,:))
        required(n1) = 1;
    end
end
% Counting those terms
disp(['Number of sum terms:        ' int2str(sum(present_p))])
disp(['Number of difference terms: ' int2str(sum(present_m))])
%
N_theo = n_harmo*(2*n_harmo-1);
disp(['Number of terms is                         ' int2str(N_eval) ' instead of ' int2str(N_theo) ...
    '. Gain: ' int2str(floor(100*(1-N_eval / N_theo))) '%'])
disp(['Number of first order useful components is ' int2str(sum(required)) ' instead of ' int2str(n_harmo) ...
    '. Gain: ' int2str(floor(100*(1-sum(required) / n_harmo))) '%'])
%
function [omega_p, omega_m, beta_p, beta_m] = calc_pm_omega_wnb(eval_inter, present_p, present_m, omega, harmo, n_harmo, h_wait)
omega_p = zeros(1,2*harmo(n_harmo));
omega_m = zeros(1,harmo(n_harmo));
beta_p  = zeros(1,2*harmo(n_harmo));
beta_m  = zeros(1,harmo(n_harmo));
for n1=n_harmo:-1:1
    for n2=1:n1-1
        if eval_inter(n1,n2) == 1
            if present_p(harmo(n1)+harmo(n2)) == 1
                omega_p(harmo(n1)+harmo(n2))   = omega(n1)+omega(n2);
                wv_plus                        = info('pulsation', omega_p(harmo(n1)+harmo(n2)));
                beta_p(harmo(n1)+harmo(n2))    = get(wv_plus,  'wavenumber');
                present_p(harmo(n1)+harmo(n2)) = 2;
            end
            if present_m(abs(harmo(n1)-harmo(n2))) == 1
                omega_m(abs(harmo(n1)-harmo(n2)))   = abs(omega(n1)-omega(n2));
                wv_minus                            = info('pulsation', omega_m(abs(harmo(n1)-harmo(n2))));
                beta_m(abs(harmo(n1)-harmo(n2)))    = get(wv_minus, 'wavenumber');
                present_m(abs(harmo(n1)-harmo(n2))) = 2;
            end
        end
    end
    wait_time_bar(h_wait, 1-(n1-1)/n_harmo * (n1-1+1)/(n_harmo+1), 'Evaluating summ and diff freq and wnb')
end
