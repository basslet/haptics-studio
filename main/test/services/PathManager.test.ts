import path from 'path';

import PathManager from '../../src/services/PathManager';

describe('PathManager', () => {
  describe('getReleaseNotesPath', () => {
    it('reads release-notes.md from the resources directory, where the builds ship it', () => {
      const resources = '/Applications/Haptics Studio.app/Contents/Resources';
      jest
        .spyOn(PathManager.instance, 'getResourcesPath')
        .mockReturnValue(resources);

      expect(PathManager.instance.getReleaseNotesPath()).toBe(
        path.join(resources, 'release-notes.md'),
      );
    });
  });
});
