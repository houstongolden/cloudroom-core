// BAMF blue: the default look of the BAMF fork. Same derivations as the upstream
// default theme, with BAMF's blue accent in place of Cloudroom's green. The
// upstream green stays available as the "Cloudroom green" theme.
export const bamfThemeCss = `
:root, .light {
  --border: color-mix(in oklab, var(--primary) 35%, var(--canvas));
  --border-hairline: color-mix(in oklab, var(--primary) 38%, var(--canvas));
  --border-seam: color-mix(in oklab, var(--primary) 30%, var(--canvas));
  --sidebar-border: color-mix(in oklab, var(--primary) 35%, var(--canvas));
  --input: color-mix(in oklab, var(--primary) 80%, var(--canvas));
  --timeline-accent: var(--primary);
  --file-accent: var(--timeline-accent);
}
.dark {
  --primary: #5b8cff;
  --primary-text: #8ab4ff;
  --primary-foreground: #ffffff;
  --border: color-mix(in oklab, var(--primary) 34%, var(--canvas));
  --border-hairline: color-mix(in oklab, var(--primary) 36%, var(--canvas));
  --border-seam: color-mix(in oklab, var(--primary) 40%, var(--canvas));
  --sidebar-border: color-mix(in oklab, var(--primary) 34%, var(--canvas));
  --input: color-mix(in oklab, var(--primary) 60%, var(--canvas));
  --timeline-accent: var(--primary);
  --file-accent: var(--timeline-accent);
  --ring: var(--primary);
  --sidebar-ring: var(--ring);
}
:root:not(.dark), .light {
  --primary: #3d6cf0;
  --primary-foreground: #ffffff;
  --primary-text: #2f57d6;
  --ring: var(--primary);
  --sidebar-ring: var(--ring);
  --skill-mention-foreground: var(--primary);
}
`;
