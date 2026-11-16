# Brand Implementation Notes

## Implemented Features

1. **Brand System**
   - Host-based brand selection (LAMP Logistics, ANEX Holdings)
   - Folder-based brand selection
   - Brand configuration via `config/brands.yml`

2. **Brand Elements Applied**
   - Logo (SVG images in `/public/brands/`)
   - Brand name throughout UI
   - URL (external website link)
   - Source URL moved to `Brand::SOURCE_URL` constant

3. **PDF Branding**
   - All PDF generators wrapped with `Current.set(brand: ...)` for proper scoping
   - Audit trails branded
   - Result attachments branded
   - Combined attachments branded

4. **Robustness**
   - Safe navigation for `submission.template&.folder&.name`
   - Fallback to default brand on bad config keys
   - Request-aware helpers that work in mailer/PDF contexts
   - Comprehensive test coverage with HTML parsing

## Deferred Features

The following brand configuration fields are present in `config/brands.yml` but not yet implemented:

1. **Primary Color (`color`)** - Currently defined but unused
   - Could be used for:
     - Custom theme colors in UI
     - Button colors
     - Link colors
     - Branding accents in PDFs

2. **Page Title** - Currently using brand name as-is
   - Could support custom page title separate from brand name
   - Example: "LAMP Sign" vs "LAMP Logistics"

3. **Favicon** - Currently using default DocuSeal favicon
   - Could support per-brand favicons
   - Would require brand-specific favicon files in public/

These features can be implemented in future iterations if needed.

## Testing

The brand spec (`spec/requests/brand_spec.rb`) validates:
- Brand name appears in visible text
- Brand logo has correct alt text
- Brand name in `data-brand-name` attributes
- Brand-specific `<title>` tag
- Source URL in page
- No leakage of other brand names
