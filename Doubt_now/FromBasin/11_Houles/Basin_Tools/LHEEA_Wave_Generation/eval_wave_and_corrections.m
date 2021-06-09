function [wv_1st, wv_2nd, wv_free] = eval_wave_and_corrections(T_repeat, fsamp, harmo, wmk)

        wv_1st = wave(T_repeat, fsamp, harmo, wmk);
        %% Correction
        wv_free = eval_free_waves(wv_1st, 400, 'hinged');
        a_free  = get(wv_free, 'ampli');
        ph_free  = get(wv_free, 'phase');
        wv_free = phase_shift(wv_free, pi);
        %wv_1st{n} = correc(n) * wv_1st{n};
        wv_2nd = wv_1st + wv_free;
        