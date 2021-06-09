function alpha_mnpq_pm = calc_alpha_mnpq_pm(k_mn, mu_n)
%
M = size(k_mn,1);
N = size(k_mn,2);
%
k_mn = repmat(k_mn, [1,1,M,N]);
k_pq = permute(k_mn, [3,4,1,2]);
%
mu_n = repmat(transpose(repmat(make_it_column(mu_n),[1,M])), [1,1,M,N]);
mu_q = permute(mu_n, [3,4,1,2]);
%
alpha_mnpq_pm(:,:,:,:,1) = sqrt((k_mn+k_pq).^2 + (mu_n + mu_q).^2);
alpha_mnpq_pm(:,:,:,:,2) = sqrt((k_mn+k_pq).^2 + (mu_n - mu_q).^2);
