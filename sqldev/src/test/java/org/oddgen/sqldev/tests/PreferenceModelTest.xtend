/*
 * Copyright 2015-2016 Philipp Salvisberg <philipp.salvisberg@trivadis.com>
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.oddgen.sqldev.tests

import com.jcabi.log.Logger
import org.junit.Assert
import org.junit.Test
import org.oddgen.sqldev.model.PreferenceModel

class PreferenceModelTest {
	@Test
	def testDefaultOfIsDiscoverPlsqlGenerators() {
		val PreferenceModel model = PreferenceModel.getInstance(null)
		Logger.info(this, "model: " + model)
		Assert.assertTrue(model.isBulkProcess)
		Assert.assertTrue(model.showClientGeneratorExamples)
		Assert.assertEquals("Client Generators", model.defaultClientGeneratorFolder)
		Assert.assertEquals("Database Server Generators", model.defaultDatabaseServerGeneratorFolder)
	}
}
