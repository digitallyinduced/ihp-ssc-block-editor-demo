-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE TYPE block_type AS ENUM ('paragraph', 'headline', 'raw_html', 'image');
CREATE TABLE blocks (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    block_type block_type NOT NULL,
    post_id UUID NOT NULL,
    order_position INT NOT NULL,
    paragraph_text TEXT,
    headline_text TEXT DEFAULT NULL,
    raw_html TEXT DEFAULT NULL,
    image_src TEXT DEFAULT NULL
);
ALTER TABLE blocks ADD CONSTRAINT blocks_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
