-- Create storage buckets
INSERT INTO storage.buckets (id, name, public) VALUES
  ('user-avatars', 'user-avatars', true),
  ('trip-images', 'trip-images', true);

-- Set up storage policies for user-avatars bucket
CREATE POLICY "Users can view all avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'user-avatars');

CREATE POLICY "Users can upload their own avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'user-avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can update their own avatar"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'user-avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can delete their own avatar"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'user-avatars' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Set up storage policies for trip-images bucket
CREATE POLICY "Anyone can view trip images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'trip-images');

CREATE POLICY "Trip members can upload trip images"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'trip-images' AND
    EXISTS (
      SELECT 1 FROM trip_members
      WHERE trip_id::text = (storage.foldername(name))[1]
      AND user_id = auth.uid()
    )
  );

CREATE POLICY "Trip members can update trip images"
  ON storage.objects FOR UPDATE
  USING (
    bucket_id = 'trip-images' AND
    EXISTS (
      SELECT 1 FROM trip_members
      WHERE trip_id::text = (storage.foldername(name))[1]
      AND user_id = auth.uid()
      AND role IN ('owner', 'admin')
    )
  );

CREATE POLICY "Trip members can delete trip images"
  ON storage.objects FOR DELETE
  USING (
    bucket_id = 'trip-images' AND
    EXISTS (
      SELECT 1 FROM trip_members
      WHERE trip_id::text = (storage.foldername(name))[1]
      AND user_id = auth.uid()
      AND role IN ('owner', 'admin')
    )
  ); 